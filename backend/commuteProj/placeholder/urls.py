from django.urls import path
from . import views

urlpatterns = [
    path('get-jeepney-routes/', views.get_jeepney_routes, name='get_jeepney_routes'),
]