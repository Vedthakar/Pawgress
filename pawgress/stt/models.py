from django.db import models

class Transcript(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    request_id = models.CharField(max_length=64, blank=True, null=True)
    text = models.TextField()                 # <- the transcript string you want
    raw = models.JSONField(blank=True, null=True)  # optional: keep full payload for debugging

    def __str__(self):
        return f"{self.created_at:%Y-%m-%d %H:%M} - {self.text[:40]}..."