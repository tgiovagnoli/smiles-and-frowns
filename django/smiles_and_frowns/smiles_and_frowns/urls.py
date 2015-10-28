from django.conf.urls import include, url
from django.contrib import admin
from services import api_views, views

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    
    #user endpoints
    url(r'^api/token_auth/(?P<backend>[^/]+)/$', api_views.register_by_access_token),
    url(r'^api/signup/?', api_views.user_signup),
    url(r'^api/update/?', api_views.user_update),
    url(r'^api/login/?', api_views.user_login),
    url(r'^api/logout/?', api_views.user_logout),
    url(r'^api/user_info/?', api_views.user_info),
    url(r'^api/reset_password/?', api_views.user_password_reset),
    
    #invite endpoints
    url(r'^api/invite_accept/?',api_views.invite_accept),
    url(r'^api/invites/?',api_views.invites),
    url(r'^api/invite/?', api_views.invite),
    
    #syncing
    url(r'^api/sync/push/?', api_views.sync_from_client),
    url(r'^api/sync/?', api_views.sync_pull),

    url(r'^api/boards/?', api_views.boards),
]
