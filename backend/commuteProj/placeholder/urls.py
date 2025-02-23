from django.urls import path
from . import views

urlpatterns = [
    path('placeholder/', views.placeholder, name='placeholder'),
]