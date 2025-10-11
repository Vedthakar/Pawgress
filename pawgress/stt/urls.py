# stt/urls.py
from django.urls import path
from .views import index, transcribe_api

urlpatterns = [
    path("", index, name="index"),
    path("api/", transcribe_api, name="api"),
]
