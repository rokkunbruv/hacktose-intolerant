from django.shortcuts import render
import requests
from django.http import JsonResponse
from django.conf import settings
from decouple import config

def get_routes(request):
    origin = request.GET.get('origin')
    destination = request.GET.get('destination')

    if not origin or not destination:
        return JsonResponse({'error': 'Origin and destination are required'}, status=400)

    url = f"https://routes.googleapis.com/directions/v2:computeRoutes"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": config('GOOGLE_MAPS_API_KEY'),
        "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.polyline,routes.legs,routes.transitDetails"
    }
    data = {
        "origin": {"address": origin},
        "destination": {"address": destination},
        "travelMode": "TRANSIT",
        "transitPreferences": {
            "routingPreference": "LESS_WALKING"
        },
    }

    response = requests.post(url, headers=headers, json=data)
    
    if response.status_code == 200:
        return JsonResponse(response.json())
    error_message = response.json().get('error', 'Unknown error occurred')
    return JsonResponse({'error': error_message}, status=response.status_code)


def index(request):
    context = {
        'GOOGLE_MAPS_API_KEY': config('GOOGLE_MAPS_API_KEY')
    }
    return render(request, 'index.html', context)
