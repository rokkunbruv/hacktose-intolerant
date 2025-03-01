from django.shortcuts import render
import requests
from django.http import JsonResponse
from django.conf import settings
from decouple import config

def get_routes(request):
    origin = request.GET.get('origin')
    destination = request.GET.get('destination')

    origin_coords = origin.split(',')
    origin_lat = float(origin_coords[0])
    origin_lng = float(origin_coords[1])

    destination_coords = destination.split(',')
    destination_lat = float(destination_coords[0])
    destination_lng = float(destination_coords[1])

    if not origin or not destination:
        return JsonResponse({'error': 'Origin and destination are required'}, status=400)

    url = f"https://routes.googleapis.com/directions/v2:computeRoutes"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": config('GOOGLE_MAPS_API_KEY'),
        "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.polyline,routes.legs"
    }
    data = {
        "origin": {
            "location": {
                "latLng": {
                    "latitude": origin_lat,
                    "longitude": origin_lng,
                }
            }
        },
        "destination": {
            "location": {
                "latLng": {
                    "latitude": destination_lat,
                    "longitude": destination_lng,
                }
            }
        },
        "travelMode": "TRANSIT",
        "computeAlternativeRoutes": True,
    }

    print(origin_coords, destination_coords)

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
