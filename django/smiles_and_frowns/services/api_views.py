import json
from django.http import JsonResponse, HttpResponse
from services import models, json_utils
from django.core import serializers

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")

def boards(request):
	boards = models.Board.objects.all()
	board_data = json_utils.board_info_dictionary_collection(boards, with_users=True, with_behaviors=True, with_rewards=True, with_smiles=True, with_frowns=True, with_invites=True)
	return json_response(board_data)

