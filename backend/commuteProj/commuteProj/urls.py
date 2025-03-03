from django.contrib import admin
from django.urls import include, path
from django.http import HttpResponse

def home(request):
    return HttpResponse("Hello, Tultul is running yay!")

urlpatterns = [
    path('', home, name='home'),
    path('', include('placeholder.urls')),
    path('admin/', admin.site.urls),
]
