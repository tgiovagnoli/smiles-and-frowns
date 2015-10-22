import json
from dateutil import parser
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
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
	if not request.user.is_authenticated(): 
		return login_required_response()

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
def user_signup(request):
	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	email = request.POST.get('email',None)
	password = request.POST.get('password',None)
	
	#check for email
	if not email or len(email) < 1:
		return json_response_error("email required")

	#check for password
	if not password or len(password) < 1:
		return json_response_error("password required")

	

@csrf_exempt
def user_login(request):
	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	#get username / password
	username = None
	email = request.POST.get('email',None)
	password = request.POST.get('password',None)

	#check for email
	if not email or len(email) < 1:
		return json_response_error("email required")

	#check for password
	if not password or len(password) < 1:
		return json_response_error("password required")

	#lookup user by email for their username
	user = None
	try:
		user = User.objects.get(email=email)
		username = user.username
	except:
		return json_response_error("user not found")

	#try and authenticate user
	user = None
	try: 
		user = authenticate(username=username,password=password)
	except: 
		pass

	if user is None:
		return json_response_error("invalid user")
	
	#try and login the user
	if user.is_active:
		login(request,user)
	else:
		return HttpResponse(status=http.HTTP_BAD_REQUEST)
	
	#return authed user json data	
	data = json_utils.user_info_dictionary(user)
	return json_response(data)

@csrf_exempt
def user_logout(request):
	logout(request)
	return json_response({"message": "logged out"})

@csrf_exempt
def sync_pull(request):
	if not request.user.is_authenticated(): 
		return login_required_response()

	boards = None
	try:
		board_info_dictionary = json.loads(request.body)
	except(e):
		return json_response({"message": "Could not parse request"})

	output = []
	boards = []

	boards_query = models.Board.objects.filter(owner=request.user)
	for board_record in boards_query:
		boards.append(board_record)

	user_roles = models.UserRole.objects.filter(user=request.user)
	for user_role in user_roles:
		boards.append(user_role.board)

	for board in boards:
		has_locally = False
		for board_data in board_info_dictionary:
			uuid = board_data["uuid"]
			edit_count = board_data["edit_count"]
			sync_date = parser.parse(board_data["sync_date"])
			
			if board.uuid == uuid:
				has_locally = True
				if board.device_date > sync_date:
					sync_data = get_sync_for_board(board, sync_date)
					output.append(sync_data)
		if not has_locally:
			sync_data = get_sync_for_board(board, board.created_date)
			output.append(sync_data)

	return json_response(output)

def sync_pull2(request):
	data = json.loads(request.body)
	sync_date = json_utils.date_fromstring(data.get('sync_date'))
	client_boards = data.get('boards')
	boards = []
	board_uuids = []
	for client_board in client_boards:
		try:
			board = models.Board.objects.get(uuid=client_board.get('uuid'),edit_count__gt=client_board.get('edit_count'),device_date__gt=sync_date)
			board_uuids.append(board.uuid)
			boards.append(board)
		except:
			pass
	new_boards = models.Board.objects.filter(~Q(uuid__in=board_uuids), Q(device_date__gt=sync_date))
	for board in new_boards:
		boards.append(board)
	output = []
	for board in boards:
		sync_data = get_sync_for_board(board, sync_date)
		output.append(sync_data)
	return json_response(output)


@csrf_exempt
def sync_from_client(request):
	if not request.user.is_authenticated(): 
		return login_required_response()

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
			if board.device_date > json_utils.date_fromstring(client_board.get('device_date')):
				continue
		
		if created:
			board_owner = None
			try:
				board_owner = User.get(username=client_board.get("user_owner_username"))
			except:
				return json_response_error("Client sync error, user with username(%@) not found on server." % (client_frown.get("user_owner_username")))
			
			if board_owner != request.user:
				return json_response_error("Client sync error, user with username(%@) not found on server." % (client_frown.get("user_owner_username")))
			board.owner = request.user
		
		board.device_date = json_utils.date_fromstring( client_board.get('device_date') )
		board.title = client_board.get('title')
		board.transaction_id = client_board.get('transaction_id')
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
			if behavior.device_date > json_utils.date_fromstring( client_behavior.get('device_date') ):
				continue

		behavior.device_date = json_utils.date_fromstring( client_behavior.get('device_date') )
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
			if smile.device_date > json_utils.date_fromstring( client_smile.get('device_date') ):
				continue

		smile.device_date = json_utils.date_fromstring( client_smile.get('device_date') )
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
		frown,created = models.Frown.objects.get_or_create(uuid=client_frown.get('uuid'))
		if not created:
			if frown.device_date > json_utils.date_fromstring( client_frown.get('device_date') ):
				continue

		frown.device_date = json_utils.date_fromstring( client_frown.get('device_date') )
		frown.board = board
		frown.user = user
		frown.behavior = behavior
		frown.save()

	#go through rewards
	client_rewards = data.get('rewards')
	for client_reward in client_rewards:
		#get board for reward.board
		try:
			board = models.Board.objects.get(uuid=client_reward.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%@) not found on server." % (client_reward.get('board_uuid')))

		#get or create reward
		reward,created = models.Reward.objects.get_or_create(uuid=client_reward.get('uuid'))
		if not created:
			if reward.device_date > json_utils.date_fromstring(client_reward.get('device_date')):
				continue

		reward.title = client_reward.get('title')
		reward.currenty_amount = client_reward.get('currenty_amount')
		reward.smile_amount = client_reward.get('smile_amount')
		reward.currency_type = client_reward.get('currency_type')
		reward.board = board
		reward.save()
