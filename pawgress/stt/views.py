import json
from django.conf import settings
from django.http import JsonResponse, HttpResponseBadRequest
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from deepgram import Deepgram
from asgiref.sync import sync_to_async          # <-- add this
from .models import Transcript                   # <-- add this

DG_CLIENT = Deepgram(settings.DEEPGRAM_API_KEY)

def index(request):
    return render(request, "indextest.html")

@csrf_exempt
async def transcribe_api(request):
    if request.method != "POST":
        return HttpResponseBadRequest("Invalid HTTP method")
    try:
        url = request.POST.get("url")
        features = request.POST.get("features") or "{}"
        model = request.POST.get("model") or "nova-2"
        version = request.POST.get("version") or ""
        tier = request.POST.get("tier") or ""

        dg_features = json.loads(features)
        dg_features["model"] = model
        if version:
            dg_features["version"] = version
        if model == "whisper" and tier:
            dg_features["tier"] = tier

        dg_request = None
        if "file" in request.FILES:
            f = request.FILES["file"]
            dg_request = {"mimetype": f.content_type, "buffer": f.read()}
        elif url:
            dg_request = {"url": url}
        if not dg_request:
            return HttpResponseBadRequest(json.dumps({"err": "Provide a 'file' or a 'url'."}))

        # Call Deepgram (async)
        result = await DG_CLIENT.transcription.prerecorded(dg_request, dg_features)

        # Extract the transcript string safely
        transcript_text = (
            result.get("results", {})
                  .get("channels", [{}])[0]
                  .get("alternatives", [{}])[0]
                  .get("transcript", "")
        )
        request_id = result.get("metadata", {}).get("request_id")

        # Save to DB (sync ORM -> wrap with sync_to_async)
        await sync_to_async(Transcript.objects.create)(
            text=transcript_text,
            request_id=request_id,
            raw=result,                # optional; remove if you only want text
        )

        return JsonResponse({
            "model": model,
            "version": version,
            "tier": tier,
            "dgFeatures": dg_features,
            "transcription": result,
            "saved_text": transcript_text,
        })
    except Exception as e:
        return HttpResponseBadRequest(json.dumps({"err": str(e)}))
