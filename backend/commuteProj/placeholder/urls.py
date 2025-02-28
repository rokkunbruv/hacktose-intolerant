from django.urls import path
from . import views

urlpatterns = [
    path('routes/', views.get_routes, name='get_routes'),
]