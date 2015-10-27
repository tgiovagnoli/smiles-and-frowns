import json,uuid,datetime
from dateutil import parser
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.core import serializers
from django.core.mail import EmailMultiAlternatives
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
from django.template import Context, loader
from services import models, json_utils, utils
from smiles_and_frowns import settings
from social.apps.django_app.utils import psa
from pytz import UTC

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")

def json_response_error(error_message):
	return HttpResponse(json.dumps({'error':error_message}, indent=4), content_type="application/json")

def login_required_response():
	return json_response({"error": "login required"})

def boards(request):
	if not request.user.is_authenticated(): 
		return login_required_response()
	boards = models.Board.objects.all()
	board_data = json_utils.board_info_dictionary_collection(boards, with_users=True, with_behaviors=True, with_rewards=True, with_smiles=True, with_frowns=True, with_invites=True)
	return json_response(board_data)

@psa('social:complete')
def register_by_access_token(request,backend):
	#http://python-social-auth.readthedocs.org/en/latest/use_cases.html
	#This view expects an access_token GET parameter, if it's needed,
	#request.backend and request.strategy will be loaded with the current
	#backend and strategy.
	
	if request.method != "POST":
		return json_response_error("method not allowed")
	
	if "access_token" not in request.POST:
		return json_response_error("no access token")

	access_token = request.POST.get('access_token')
	
	if backend == "twitter":
		if "access_token_secret" not in request.POST:
			return json_response_error('no access token secret')
		access_token = {
			"oauth_token":request.POST.get('access_token'),
			"oauth_token_secret":request.POST.get('access_token_secret'),
		}
	
	user = request.backend.do_auth(access_token)
	
	if user:
		login(request,user)
		return json_response({})
	
	return json_response_error("user not found")

@csrf_exempt
def user_password_reset(request):
	'''
	@param email
	'''

	#post only
	if request.method != "POST":
		return json_response_error("method not allowed")
	
	#get email
	email = request.POST.get('email',None)
	if not email or len(email) < 1:
		return json_response_error("email required")

	#get user
	try:
		user = User.objects.get(email=email)
	except:
		return json_response_error("user not found")

	#new password
	new_password = utils.random_password()

	#load template
	data = {"password":new_password}
	context = Context(data)
	toEmail = [user.email]
	fromEmail = settings.EMAIL_DO_NOT_REPLY
	subject = "Smiles & Frowns Password Reset"
	template_plain = loader.get_template("email_password_reset.txt")
	template_html = loader.get_template("email_password_reset.html")
	body_plain = template_plain.render(context)
	body_html = template_html.render(context)
	
	#print "new password: " + new_password

	#send email
	try:
		message = EmailMultiAlternatives(subject,body_plain,fromEmail,toEmail)
		message.attach_alternative(body_html,"text/html")
		if message.send() != 1:
			return json_response_error("error sending email")
	except:
		return json_response_error("error sending email")

	#response
	return json_response({})

@csrf_exempt
def user_signup(request):
	'''
	@param email
	@param firstname
	@param lastname
	@param gender
	@param age
	@param password
	'''

	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	email = request.POST.get('email',None)
	password = request.POST.get('password',None)
	firstname = request.POST.get('firstname',None)
	lastname = request.POST.get('lastname',None)
	gender = request.POST.get('gender',None)
	age = request.POST.get('age',None)
	
	#check for email
	if not email or len(email) < 1:
		return json_response_error("email required")

	#check for user with email
	try:
		user = User.objects.get(email=email)
	except:
		return json_response_error("email already registered")

	#check for firstname
	if not firstname or len(firstname) < 1:
		return json_response_error("firstname required")

	#check lastname
	if not lastname or len(lastname) < 1:
		return json_response_error("lastname required")

	#check gender
	if not gender or len(gender) < 1:
		return json_response_error("gender required")

	#check age
	if not age or len(age) < 1:
		return json_response_error("age required")

	#check for password
	if not password or len(password) < 1:
		return json_response_error("password required")

	#create random username with uuid
	username = str(uuid.uuid4())

	#create user
	try:
		new_user = User(email=email,username=username,first_name=firstname,last_name=lastname,password=make_password(password))
		new_user.save()
		new_user.profile.age = age
		new_user.profile.gender = gender
		new_user.profile.save()
	except Exception as e:
		return json_response_error('error creating user %s' % str(e))

	output = json_utils.user_info_dictionary(new_user)
	return json_response(output)

@csrf_exempt
def user_update(request):
	'''
	@param email
	@param password
	@param password_confirm
	@param firstname
	@param lastname
	@param age
	@param gender
	'''

	#check post
	if request.method != POST:
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated():
		return login_required_response()

	email = request.POST.get('email',None)
	password = request.POST.get('password',None)
	password_confirm = request.POST.get('password_confirm',None)
	firstname = request.POST.get('firstname',None)
	lastname = request.POST.get('lastname',None)
	age = request.POST.get('age',None)
	gender = request.POST.get('gender',None)

	if email:
		request.user.email = email

	if firstname:
		request.user.first_name = firstname

	if lastname:
		request.user.last_name = lastname

	if password and password_confirm and password == password_confirm:
		user.set_password( make_password(password) )

	if age:
		request.user.profile.age = age

	if gender:
		request.user.profile.gender = gender

	request.user.save()
	request.user.profile.save()
	
	data = json_utils.user_info_dictionary(user)
	return json_response(data)

@csrf_exempt
def user_login(request):
	'''
	@param email
	@param password
	'''

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
	return json_response({})

@csrf_exempt
def invites(request):
	#check auth
	if not request.user.is_authenticated():
		return login_required_response()
	invites = models.Invite.objects.filter(user=request.user)
	output = json_utils.invite_info_dictionary_collection(invites,with_boards=True,with_users=True)
	return json_response(output)

@csrf_exempt
def invite_accept(request):
	'''
	@param code
	'''

	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated():
		return login_required_response()

	#get code
	code = request.POST.get('code')
	if not code or len(code) < 1:
		return json_response_error("accept code required")

	#find invite
	try:
		invite = models.Invite.objects.get(code=code)
	except:
		return json_response_error("invite not found")
	
	#create a user role
	user_role,created = models.UserRole.objects.get_or_create(board=invite.board,user=request.user,role=invite.role)
	if created:
		user_role.save()

	#delete invite
	invite.delete()

	#returns all new data
	data = get_sync_for_board(invite.board,UTC.localize(datetime.datetime.utcnow()),is_new=True)
	return json_response(data)

@csrf_exempt
def invite(request):
	'''
	@param role - PROFILE_ROLE_CHOICES from models.py
	@param board_uuid - the board uuid being invited to
	@param invitee_email - the person being invited
	@param invitee_firstname - invitee firstname
	@param invitee_lastname - invitee lastname
	'''
	
	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated(): 
		return login_required_response()

	#get inviter user
	inviter_user = request.user

	#get board
	try:
		board = models.Board.objects.get(uuid=request.POST.get('board_uuid',None))
	except:
		return json_response_error("Board with uuid(%s) not found." % (board_uuid))

	#check request user is owner or board
	#if board.owner != request.user:
	#	return json_response_error("Requesting user is not the board owner.")

	#get role
	role = request.POST.get('role',None)
	if not role or len(role) < 1:
		return json_response_error("role required")

	#get email for initee
	invitee_email = request.POST.get('invitee_email',None)
	if not invitee_email or len(invitee_email) < 1:
		return json_response_error("invitee_email required")

	#get invitee first name
	invitee_firstname = request.POST.get('invitee_firstname',None)
	if not invitee_firstname or len(invitee_firstname) < 1:
		return json_response_error("invitee_firstname required")

	#get invitee last name
	invitee_lastname = request.POST.get('invitee_lastname',None)
	if not invitee_lastname or len(invitee_lastname) < 1:
		return json_response_error("invitee_lastname required")

	#try and find a user with the provided invitee_email.
	send_email_with_code = True
	invitee_user = None
	try:
		invitee_user = User.objects.get(email=invitee_email)
		send_email_with_code = False
	except:
		print "invitee_user not found, using no invitee_user for invite"

	#if the invitee has a user already, use the provided first name and last name from their user account
	if invitee_user and invitee_user.first_name:
		invitee_firstname = invitee_user.first_name
	if invitee_user and invitee_user.last_name:
		invitee_lastname = invitee_user.last_name

	#generate invite code
	code = utils.invite_code()

	#lookup if there's an existing invite for user/board/role.
	invite,created = models.Invite.objects.get_or_create(user=invitee_user,board=board,role=role)
	
	#new invite, set new code
	if created:
		invite.code = code
	
	#existing invite, use the invites existing code in the email
	else:
		code = invite.code
	
	invite.save()

	#setup template data for email
	data = {
		'code':code,
		'board':board,
		'inviter':inviter_user,
		'invitee_email':invitee_email,
		'invitee_firstname':invitee_firstname,
		'invitee_lastname':invitee_lastname
	}
	context = Context(data)
	toEmail = [invitee_email]
	fromEmail = settings.EMAIL_DO_NOT_REPLY
	subject = "You're invited to particiate in a Smiles and Frowns board!"
	
	#use template that has code included.
	if send_email_with_code:
		template_plain = loader.get_template("invite_with_code.txt")
		template_html = loader.get_template("invite_with_code.html")
	
	#use template that has no code included.
	else:
		template_plain = loader.get_template("invite_no_code.txt")
		template_html = loader.get_template("invite_no_code.html")
	
	#get body
	body_plain = template_plain.render(context)
	body_html = template_html.render(context)
	
	#send email
	try:
		message = EmailMultiAlternatives(subject,body_plain,fromEmail,toEmail)
		message.attach_alternative(body_html,"text/html")
		message.send()
	except:
		return json_response_error("error sending email")

	#response
	return json_response({})

@csrf_exempt
def get_sync_for_board(board, sync_date, is_new=False):
	sync_data = {
		"board": json_utils.board_info_dictionary(board)
	}
	
	if is_new:
		users_roles = models.UserRole.objects.filter(board=board)
	else:
		users_roles = models.UserRole.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["user_roles"] = json_utils.user_role_info_dictionary_collection(users_roles, with_users=True)

	if is_new:
		behaviors = models.Behavior.objects.filter(board=board)
	else:
		behaviors = models.Behavior.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["behaviors"] = json_utils.behavior_info_dictionary_collection(behaviors)

	if is_new:
		rewards = models.Reward.objects.filter(board=board)
	else:
		rewards = models.Reward.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["rewards"] = json_utils.reward_info_dictionary_collection(rewards)

	if is_new:
		smiles = models.Smile.objects.filter(board=board)
	else:
		smiles = models.Smile.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["smiles"] = json_utils.smile_info_dictionary_collection(smiles)

	if is_new:
		frowns = models.Frown.objects.filter(board=board)
	else:
		frowns = models.Frown.objects.filter(board=board, device_date__gt=sync_date)
	sync_data["frowns"] = json_utils.frown_info_dictionary_collection(frowns)

	return sync_data

@csrf_exempt
def sync_pull(request):
	#check auth
	if not request.user.is_authenticated(): 
		return login_required_response()

	#get incoming board
	try:
		board_info_dictionary = json.loads(request.body)
	except:
		return json_response_error("could not parse request")

	#make sure an array of boards is sent to sync
	if utils.is_array(board_info_dictionary) == False:
		return json_response_error("could not parse request")

	output = []
	boards = []

	#get all boards for request.user
	boards_query = models.Board.objects.filter(owner=request.user)
	for board_record in boards_query:
		boards.append(board_record)

	#get all boards that user is participating in
	user_roles = models.UserRole.objects.filter(user=request.user)
	for user_role in user_roles:
		boards.append(user_role.board)

	#go through boards and append it's serialized data to output
	for board in boards:
		has_locally = False
		
		for board_data in board_info_dictionary:
			uuid = board_data["uuid"]
			edit_count = board_data["edit_count"]
			sync_date = parser.parse(board_data["sync_date"])
			
			#board is in incoming request to sync
			if board.uuid == uuid:
				has_locally = True
				if board.device_date > sync_date:
					sync_data = get_sync_for_board(board, sync_date)
					output.append(sync_data)

		#didn't have this board in incoming request, add to output
		if not has_locally:
			sync_data = get_sync_for_board(board, board.created_date, True)
			output.append(sync_data)

	return json_response(output)


@csrf_exempt
def sync_from_client(request):
	'''
	Request body should be json:
	{'boards':[], 'behaviors':[], 'smiles':[], 'frowns':[], 'rewards':[], 'user_roles':[]}
	'''
	if not request.user.is_authenticated(): 
		return login_required_response()

	#get JSON body
	json_string = request.body
	data = json.loads(json_string)

	#go through boards the client sent us.
	#boards have to be available for most other object so these should be created first.
	client_boards = data.get('boards',[])
	for client_board in client_boards:
		#get or create board
		created = False
		try:
			board = models.Board.objects.get(uuid=client_board.get("uuid"))
		except:
			created = True
			board = models.Board(uuid=client_board.get("uuid"), owner=request.user)

		if not created:
			if board.device_date > json_utils.date_fromstring(client_board.get('device_date')):
				continue
		
		if created:
			board_owner = None
			try:
				board_owner = User.objects.get(username=client_board.get("owner_username"))
			except:
				return json_response_error("Client sync error, user with username (%s) not found on server." % (client_board.get("owner_username")))
			
			if board_owner != request.user:
				return json_response_error("Client sync error, user with username (%s) is not the logged in user." % (client_board.get("owner_username")))
			board.owner = request.user
		
		board.deleted = client_board.get('deleted',False)
		board.device_date = json_utils.date_fromstring( client_board.get('device_date') )
		board.title = client_board.get('title')
		board.transaction_id = client_board.get('transaction_id')
		board.save()

	#go through user roles
	client_roles = data.get("user_roles",[])
	for client_role in client_roles:
		#find board
		try:
			board = models.Board.objects.get(uuid=client_role.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (client_role.get('board_uuid')))

		#get provided user info about role
		userinfo = client_role.get('user',None)
		if not userinfo:
			return json_response_error("Client sync error, userinfo not provided for role with uuid %s" (client_role.get('uuid')))

		#find or create role
		role,created = models.UserRole.objects.get_or_create(uuid=client_role.get('uuid'))
		if not created:
			if role.device_date > json_utils.date_fromstring(client_role.get('device_date')):
				continue

		#try and find existing user in DB
		user,created = User.objects.get_or_create(username=userinfo.get('username'))
		if created:
			user.email = userinfo.get('email',None)
			user.first_name = userinfo.get('firstname',None)
			user.last_name = userinfo.get('lastname',None)
			#sets a random password for new users.
			user.set_password(utils.random_password())
		user.save()

		role.deleted = client_role.get('deleted',False)
		role.device_date = json_utils.date_fromstring(client_role.get('device_date'))
		role.user = user
		role.board = board
		role.role = client_role.get('role')
		role.save()

	#go through behaviors
	client_behaviors = data.get('behaviors',[])
	for client_behavior in client_behaviors:
		#get board for behavior.board
		try:
			board = models.Board.objects.get(uuid=client_behavior.get("board_uuid"))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (client_behavior.get('board_uuid')))

		#get or create behavior
		behavior,created = models.Behavior.objects.get_or_create(uuid=client_behavior.get('uuid'))
		if not created:
			if behavior.device_date > json_utils.date_fromstring( client_behavior.get('device_date')):
				continue

		behavior.deleted = client_behavior.get('deleted',False)
		behavior.device_date = json_utils.date_fromstring( client_behavior.get('device_date') )
		behavior.title = client_behavior.get('title')
		behavior.note = client_behavior.get('note')
		behavior.board = board
		behavior.save()

	#go through smiles
	client_smiles = data.get('smiles',[])
	for client_smile in client_smiles:
		#get user for smile.user
		try:
			user = User.objects.get(username=client_smile.get('user_username'))
		except:
			return json_response_error("Client sync error, user with username(%s) not found on server." % (client_smile.get('user_username')))
		
		#get board for smile.board
		try:
			board = models.Board.objects.get(uuid=client_smile.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (client_smile.get('board_uuid')))
		
		#get behavior for smile.behavior
		try:
			behavior = models.Behavior.objects.get(uuid=client_smile.get('behavior_uuid'))
		except:
			return json_response_error("Client sync error, behavior with uuid(%s) not found on server." % (client_smile.get('behavior_uuid')))

		#get or create smile
		smile,created = models.Smile.objects.get_or_create(uuid=client_smile.get('uuid'))
		if not created:
			if smile.device_date > json_utils.date_fromstring( client_smile.get('device_date')):
				continue

		smile.user=user
		smile.board=board
		smile.behavior=behavior
		smile.deleted = client_smile.get('deleted',False)
		smile.device_date = json_utils.date_fromstring( client_smile.get('device_date') )
		smile.collected = client_smile.get('collected')
		smile.save()

	#go throgh frowns
	client_frowns = data.get('frowns',[])
	for client_frown in client_frowns:
		#get user for frown.user
		try:
			user = User.objects.get(username=client_frown.get('user_username'))
		except:
			return json_response_error("Client sync error, user with username(%s) not found on server." % (client_frown.get('user_username')))
		
		#get board for frown.board
		try:
			board = models.Board.objects.get(uuid=client_frown.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (client_frown.get('board_uuid')))
		
		#get behavior for frown.behavior
		try:
			behavior = models.Behavior.objects.get(uuid=client_frown.get('behavior_uuid'))
		except:
			return json_response_error("Client sync error, behavior with uuid(%s) not found on server." % (client_frown.get('behavior_uuid')))

		#get or create frown
		frown,created = models.Frown.objects.get_or_create(uuid=client_frown.get('uuid'))
		if not created:
			if frown.device_date > json_utils.date_fromstring( client_frown.get('device_date')):
				continue

		frown.user = user
		frown.board = board
		frown.behavior = behavior
		frown.deleted = client_frown.get('deleted',False)
		frown.device_date = json_utils.date_fromstring( client_frown.get('device_date') )
		frown.save()

	#go through rewards
	client_rewards = data.get('rewards',[])
	for client_reward in client_rewards:
		#get board for reward.board
		try:
			board = models.Board.objects.get(uuid=client_reward.get('board_uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (client_reward.get('board_uuid')))

		#get or create reward
		reward,created = models.Reward.objects.get_or_create(uuid=client_reward.get('uuid'))
		if not created:
			if reward.device_date > json_utils.date_fromstring(client_reward.get('device_date')):
				continue

		reward.board = board
		reward.deleted = client_reward.get('deleted',False)
		reward.title = client_reward.get('title')
		reward.currency_amount = client_reward.get('currency_amount')
		reward.smile_amount = client_reward.get('smile_amount')
		reward.currency_type = client_reward.get('currency_type')
		reward.save()

	return json_response({})
