import json
from dateutil import parser
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.models import User
from django.core import serializers
from django.views.decorators.csrf import csrf_exempt
from services import models, json_utils

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")

def json_response_error(error_message):
	return HttpResponse(json.dumps({'message':error_message}, indent=4), content_type="application/json")	

def login_required_response():
	message = {
		"message": "login required"
	}
	return json_response(message)

def boards(request):
	#check authenticated
	if not request.user.is_authenticated(): return login_required_response()

	boards = models.Board.objects.all()
	board_data = json_utils.board_info_dictionary_collection(boards, with_users=True, with_behaviors=True, with_rewards=True, with_smiles=True, with_frowns=True, with_invites=True)
	return json_response(board_data)


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



def sync_from_client(request):
	#check authenticated
	if not request.user.is_authenticated(): return login_required_response()

	#get JSON body
	json_string = request.body
	data = json.loads(json_string)

	#go through boards the client sent us.
	#boards have to be available for most other object so these should be created first.
	client_boards = data.get('boards')
	for client_board in client_boards:
		
		#get or create board
		board,created = models.Board.objects.get_or_create(uuid=client_board.get('uuid'))
		if not created:
			if board.updated_date > json_utils.date_fromstring( client_board.get('device_date') ):
				continue
		
		#TODO: How do we properly set the board.owner?
		board.owner = request.user
		
		board.title = client_board.get('title')
		board.in_app_purchase_id = client_board.get('in_app_purchase_id')
		board.save()

	#go through behaviors
	client_behaviors = data.get('behaviors')
	for client_behavior in client_behaviors:
		#get board for behavior.board
		try:
			board = models.Board.objects.get(uuid=client_behavior.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%@) not found on server." % (client_behavior.get('board_uuid')))

		#get or create behavior
		behavior,created = models.Behavior.objects.get_or_create(uuid=client_behavior.get('uuid'))
		if not created:
			if behavior.updated_date > json_utils.date_fromstring( client_behavior.get('device_date') ):
				continue

		behavior.title = client_behavior.title
		behavior.note = client_behavior.note
		behavior.board = board
		behavior.save()

	#go through smiles
	client_smiles = data.get('smiles')
	for client_smile in client_smiles:
		#get user for smile.user
		try:
			user = User.objects.get(username=client_smile.get('user_username'))
		except:
			return json_response_error("Client sync error, user with username(%@) not found on server." % (client_smile.get('user_username')))
		
		#get board for smile.board
		try:
			board = models.Board.objects.get(uuid=client_smile.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%@) not found on server." % (client_smile.get('board_uuid')))
		
		#get behavior for smile.behavior
		try:
			behavior = models.Behavior.objects.get(uuid=client_smile.get('behavior_uuid'))
		except:
			return json_response_error("Client sync error, behavior with uuid(%@) not found on server." % (client_smile.get('behavior_uuid')))

		#get or create smile
		smile,created = models.Smile.objects.get_or_create(uuid=client_smile.get('uuid'))
		if not created:
			if smile.updated_date > json_utils.date_fromstring( client_smile.get('device_date') ):
				continue
		smile.user = user
		smile.board = board
		smile.behavior = behavior
		smile.collected = client_smile.get('collected')
		smile.save()

	#go throgh frowns
	client_frowns = data.get('frowns')
	for client_frown in client_frowns:
		#get user for frown.user
		try:
			user = User.objects.get(username=client_frown.get('user_username'))
		except:
			return json_response_error("Client sync error, user with username(%@) not found on server." % (client_frown.get('user_username')))
		
		#get board for frown.board
		try:
			board = models.Board.objects.get(uuid=client_frown.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%@) not found on server." % (client_frown.get('board_uuid')))
		
		#get behavior for frown.behavior
		try:
			behavior = models.Behavior.objects.get(uuid=client_frown.get('behavior_uuid'))
		except:
			return json_response_error("Client sync error, behavior with uuid(%@) not found on server." % (client_frown.get('behavior_uuid')))

		#get or create frown
		frown,created = models.Frown.objects.get_or_create(client_frown.get('uuid'))
		if not created:
			if frown.updated_date > json_utils.date_fromstring( client_frown.get('device_date') ):
				continue

		frown.board = board
		frown.user = user
		frown.behavior = behavior
		frown.save()

