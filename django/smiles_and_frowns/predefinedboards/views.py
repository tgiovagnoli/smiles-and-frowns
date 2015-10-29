import json
from django.shortcuts import render
from django.http import JsonResponse, HttpResponse

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")
