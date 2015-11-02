from requests import request, HTTPError
from django.core.files.base import ContentFile

def save_email(strategy, user, response, details, is_new=False, *args, **kwargs):
    backend = kwargs['backend']
    url = None
    params = {}
    
    print "RESPONSE"
    print details
    print response
    print user

    if backend.name == 'facebook':
        print response
        
    
    #if backend.name == 'twitter':
    #    if not user.profile.image or is_new:
    #        url = response['profile_image_url']
    #        url = "_bigger".join(url.split("_normal"))
    
    #if not url:
    #    return

    #try:
    #    response = request('GET',url,params=params)
    #    response.raise_for_status()
    #except HTTPError:
    #    return
    #profile = user.profile
    #profile.image.save('{0}_social.jpg'.format(user.username),ContentFile(response.content))
    #profile.save()
    