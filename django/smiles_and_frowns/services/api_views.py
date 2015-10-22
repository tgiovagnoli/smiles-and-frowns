import json
from dateutil import parser
from django.http import JsonResponse, HttpResponse
from services import models, json_utils
from django.core import serializers
from django.views.decorators.csrf import csrf_exempt

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")

def login_required_response():
	message = {
		"message": "login required"
	}
	return json_response(message)

def boards(request):
	#check authenticated
	if not request.user.is_authenticated(): 
		return login_required_response()

	boards = models.Board.objects.all()
	board_data = json_utils.board_info_dictionary_collection(boards, with_users=True, with_behaviors=True, with_rewards=True, with_smiles=True, with_frowns=True, with_invites=True)
	return json_response(board_data)

def get_or_none(model, *args, **kwargs):
    try:
        return model.objects.get(*args, **kwargs)
    except model.DoesNotExist:
        return None


def get_sync_for_board(board, sync_date):
	sync_data = {
		"board": json_utils.board_info_dictionary(board)
	}
	#send back the user roles
	users_roles = models.UserRole.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["user_roles"] = json_utils.user_role_info_dictionary_collection(users_roles, with_users=True)

	behaviors = models.Behavior.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["behaviors"] = json_utils.behavior_info_dictionary_collection(behaviors)

	rewards = models.Reward.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["rewards"] = json_utils.reward_info_dictionary_collection(rewards)

	smiles = models.Smile.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["smiles"] = json_utils.smile_info_dictionary_collection(smiles)

	frowns = models.Frown.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["frowns"] = json_utils.frown_info_dictionary_collection(frowns)

	return sync_data



@csrf_exempt
def sync_pull(request):
	boards = None
	try:
		boards = json.loads(request.body)
	except(e):
		return json_response({"message": "Could not parse request"})

	output = []
	for board_data in boards:
		uuid = board_data["uuid"]
		edit_count = board_data["edit_count"]
		sync_date = parser.parse(board_data["sync_date"])
		board = None
		try:
			board = models.Board.objects.get(uuid=uuid, edit_count__gt=edit_count, device_date__gt=sync_date)
		except:
			board = None
		if board:
			sync_data = get_sync_for_board(board, sync_date)
			output.append(sync_data)



	return HttpResponse(json_response(output), content_type="application/json")
