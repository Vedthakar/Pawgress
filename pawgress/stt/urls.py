# stt/urls.py
from django.urls import path
from .views import transcribe_api

urlpatterns = [
    path("api/", transcribe_api, name="api"),
]
