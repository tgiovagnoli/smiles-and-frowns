from django.conf.urls import include, url
from django.contrib import admin
from services import api_views, views

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
]
