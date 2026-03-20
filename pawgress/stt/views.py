import json

from asgiref.sync import sync_to_async
from django.conf import settings
from django.http import HttpResponseBadRequest, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework_simplejwt.authentication import JWTAuthentication

from .models import Transcript


def _json_error(message, status=400):
    return JsonResponse({"err": message}, status=status)


def _get_deepgram_client():
    if not settings.DEEPGRAM_API_KEY:
        raise RuntimeError("DEEPGRAM_API_KEY is not configured.")

    try:
        from deepgram import Deepgram
    except ImportError as exc:
        raise RuntimeError("deepgram-sdk is not installed.") from exc

    return Deepgram(settings.DEEPGRAM_API_KEY)


def _create_transcript(text, request_id, raw):
    return Transcript.objects.create(
        text=text,
        request_id=request_id,
        raw=raw,
    )


def _resolve_authenticated_user(request):
    current_user = getattr(request, "user", None)
    if getattr(current_user, "is_authenticated", False):
        return current_user

    auth_result = JWTAuthentication().authenticate(request)
    if auth_result is None:
        return None

    user, _ = auth_result
    return user


@csrf_exempt
async def transcribe_api(request):
    if request.method != "POST":
        return HttpResponseBadRequest("Invalid HTTP method")

    try:
        user = await sync_to_async(_resolve_authenticated_user)(request)
    except Exception:
        return _json_error("Invalid authentication credentials.", status=401)

    if user is None:
        return _json_error("Authentication credentials were not provided.", status=401)

    url = request.POST.get("url")
    features = request.POST.get("features") or "{}"
    model = request.POST.get("model") or "nova-2"
    version = request.POST.get("version") or ""
    tier = request.POST.get("tier") or ""

    try:
        dg_features = json.loads(features)
    except json.JSONDecodeError:
        return _json_error("'features' must be valid JSON.")

    dg_features["model"] = model
    if version:
        dg_features["version"] = version
    if model == "whisper" and tier:
        dg_features["tier"] = tier

    dg_request = None
    if "file" in request.FILES:
        uploaded_file = request.FILES["file"]
        dg_request = {
            "mimetype": uploaded_file.content_type,
            "buffer": uploaded_file.read(),
        }
    elif url:
        dg_request = {"url": url}

    if not dg_request:
        return _json_error("Provide a 'file' or a 'url'.")

    try:
        deepgram_client = _get_deepgram_client()
        result = await deepgram_client.transcription.prerecorded(dg_request, dg_features)
    except RuntimeError as exc:
        return _json_error(str(exc), status=503)
    except Exception:
        return _json_error("Transcription request failed.", status=502)

    transcript_text = (
        result.get("results", {})
        .get("channels", [{}])[0]
        .get("alternatives", [{}])[0]
        .get("transcript", "")
    )
    request_id = result.get("metadata", {}).get("request_id")

    transcript = await sync_to_async(_create_transcript)(
        text=transcript_text,
        request_id=request_id,
        raw=result,
    )

    return JsonResponse(
        {
            "model": model,
            "version": version,
            "tier": tier,
            "dgFeatures": dg_features,
            "transcription": result,
            "saved_text": transcript_text,
            "transcript_id": transcript.id,
        }
    )
