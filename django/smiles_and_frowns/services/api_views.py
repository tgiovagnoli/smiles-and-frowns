import json,uuid,datetime
from dateutil import parser
from pytz import UTC
from datetime import datetime
from django.http import JsonResponse, HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.core import serializers
from django.core.mail import EmailMultiAlternatives
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
from django.template import Context, loader
from django.db.models import Q
from services import models, json_utils, utils
from smiles_and_frowns import settings
from social.apps.django_app.utils import psa

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
	@param password
	@param password_confirm
	@param (optional) gender
	@param (optional) age
	'''

	#check for POST
	if request.method != "POST":
		return json_response_error("method not allowed")

	email = request.POST.get('email',None)
	password = request.POST.get('password',None)
	password_confirm = request.POST.get('password_confirm',None)
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
		return json_response_error("email already registered")
	except:
		pass

	#check for firstname
	if not firstname or len(firstname) < 1:
		return json_response_error("firstname required")

	#check lastname
	if not lastname or len(lastname) < 1:
		return json_response_error("lastname required")

	#check for password
	if not password or len(password) < 1:
		return json_response_error("password required")

	#check password confirm match
	if password != password_confirm:
		return json_response_error("password does not match password confirm")

	#create random username with uuid
	username = str(uuid.uuid4())

	#create user
	try:
		new_user = User(email=email,username=username,first_name=firstname,last_name=lastname,password=make_password(password))
		new_user.save()
		if age: new_user.profile.age = age
		if gender: new_user.profile.gender = gender
	except Exception as e:
		return json_response_error('error creating user %s' % str(e))

	#try and authenticate user
	user = None
	try: 
		user = authenticate(username=username,password=password)
		login(request,user)
	except Exception as e:
		return json_response_error(str(e))

	#return new user
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
def user_info(request):
	#check auth
	if not request.user.is_authenticated(): 
		return login_required_response()
	data = json_utils.user_info_dictionary(request.user)
	return json_response(data)

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

	#get return data
	output = sync_data_for_board(invite.board)

	#append invite to response output
	output['invite'] = json_utils.invite_info_dictionary(invite)

	#delete invite
	invite.delete()

	#returns all new data
	return json_response(output)

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
def invites(request):
	#check auth
	if not request.user.is_authenticated():
		return login_required_response()
	invites = models.Invite.objects.filter(user=request.user)
	output = json_utils.invite_info_dictionary_collection(invites)
	return json_response(output)

def sync_data_for_board(board):
	'''
	This doesn't take into account any sync dates. Returns ALL data for a board.
	'''
	#get associate objects for board
	behaviors = models.Behavior.objects.filter(board=board)
	smiles = models.Smile.objects.filter(board=board)
	frowns = models.Frown.objects.filter(board=board)
	rewards = models.Reward.objects.filter(board=board)
	user_roles = models.UserRole.objects.filter(board=board)

	#create output
	output = {}
	output['boards'] = [json_utils.board_info_dictionary(board)]
	output['behaviors'] = json_utils.behavior_info_dictionary_collection(behaviors)
	output['smiles'] = json_utils.smile_info_dictionary_collection(smiles)
	output['frowns'] = json_utils.frown_info_dictionary_collection(frowns)
	output['rewards'] = json_utils.reward_info_dictionary_collection(rewards)
	output['user_roles'] = json_utils.user_role_info_dictionary_collection(user_roles,with_users=True)

	return output

@csrf_exempt
def sync_pull(request, sync_date=None, created_object_uuids={'boards':[],'behaviors':[],'smiles':[],'frowns':[],'rewards':[],'user_roles':[]}):
	'''
	sync_date can be None, string, or datetime.
	created_object_uuids are objects that won't be included in query to get objects to return to user.
	'''

	#handle sync_date
	if not sync_date:
		sync_date = UTC.localize(datetime(2015,1,1))

	#if it's a string convert it to a datetime.
	if type(sync_date) == unicode or type(sync_date) == str:
		sync_date = json_utils.date_fromstring(sync_date)

	#get all boards the user owns.
	boards = []
	all_boards = models.Board.objects.filter(owner=request.user).all()
	for board in all_boards:
		boards.append(board)

	#get boards the user is participating in.
	roles = models.UserRole.objects.filter(user=request.user).all()
	for role in roles:
		if role.board and not role.board in boards:
			boards.append(role.board)

	#get associate objects for all boards.
	#uuid can't be one of the created uuids in created_object_uuids.
	#board has to be a board IN the boards array
	#device_date has to be greater than the sync_date.
	behaviors = models.Behavior.objects.filter(~Q(uuid__in=created_object_uuids['behaviors']),board__in=boards,device_date__gt=sync_date)
	smiles = models.Smile.objects.filter(~Q(uuid__in=created_object_uuids['smiles']),board__in=boards,device_date__gt=sync_date)
	frowns = models.Frown.objects.filter(~Q(uuid__in=created_object_uuids['frowns']),board__in=boards,device_date__gt=sync_date)
	rewards = models.Reward.objects.filter(~Q(uuid__in=created_object_uuids['rewards']),board__in=boards,device_date__gt=sync_date)
	user_roles = models.UserRole.objects.filter(~Q(uuid__in=created_object_uuids['user_roles']),user=request.user,device_date__gt=sync_date)

	#remove boards that don't need to be returned to user.
	remove = []
	for board in boards:
		if board.device_date < sync_date:
			remove.append(board)
		
		#if the board was just created in the request handling code, don't need to return it.
		elif board.uuid in created_object_uuids['boards']:
			remove.append(board)
	
	#remove boards
	for board in remove:
		boards.remove(board)

	#create output
	output = {'sync_date': json_utils.datestring(UTC.localize(datetime.utcnow())) }
	output['boards'] = json_utils.board_info_dictionary_collection(boards)
	output['behaviors'] = json_utils.behavior_info_dictionary_collection(behaviors)
	output['smiles'] = json_utils.smile_info_dictionary_collection(smiles)
	output['frowns'] = json_utils.frown_info_dictionary_collection(frowns)
	output['rewards'] = json_utils.reward_info_dictionary_collection(rewards)
	output['user_roles'] = json_utils.user_role_info_dictionary_collection(user_roles,with_users=True)

	return json_response(output)

@csrf_exempt
def sync(request):
	'''
	Request body should be json:
	{sync_date:date, 'boards':[], 'behaviors':[], 'smiles':[], 'frowns':[], 'rewards':[], 'user_roles':[]}

	Response body is the same:
	{sync_date:date, 'boards':[], 'behaviors':[], 'smiles':[], 'frowns':[], 'rewards':[], 'user_roles':[]}
	'''
	
	#check auth
	if not request.user.is_authenticated(): 
		return login_required_response()

	############# Handle request first

	#get JSON body
	json_string = request.body
	data = json.loads(json_string)

	#store created uuids for later
	created_object_uuids = {
		'boards':[],
		'behaviors':[],
		'smiles':[],
		'frowns':[],
		'rewards':[],
		'user_roles':[],
	}

	#go through boards the client sent us.
	#boards have to be available for most other object so these should be created first.
	client_boards = data.get('boards',[])
	for client_board in client_boards:
		
		#get or create board
		board,created = models.Board.objects.get_or_create(uuid=client_board.get("uuid"))
		board_client_date = json_utils.date_fromstring(client_board.get('updated_date'))
		
		#board wasn't created, check date and predefinied.
		if not created:


			#board is newer in database than what the client sent. ignore it.
			if board.device_date > board_client_date:
				continue
		
		#set owner
		if created and not board.owner:
			board.owner = request.user

		#set board data
		board.deleted = client_board.get('deleted',False)
		board.title = client_board.get('title', '')
		board.device_date = board_client_date
		board.transaction_id = client_board.get('transaction_id')
		board.save()

		#set created id in lookup. this is after save so the uuid is populated
		if created:
			created_object_uuids['boards'].append(board.uuid)

	#go through user roles
	client_roles = data.get("user_roles", [])
	for client_role in client_roles:
		client_role_date = json_utils.date_fromstring(client_role.get('updated_date'))
		
		#find board
		try:
			board_dict = client_role.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) not found on server." % (board_dict.get('uuid')))

		#get provided user info about role
		userinfo = client_role.get('user', None)
		if not userinfo:
			return json_response_error("Client sync error, userinfo not provided for role with uuid %s" (client_role.get('uuid')))

		#try and find existing user in DB
		user,created = User.objects.get_or_create(username=userinfo.get('username'))
		if created:
			user.email = userinfo.get('email', "")
			user.first_name = userinfo.get('first_name', "")
			user.last_name = userinfo.get('last_name', "")
			#sets a random password for new users.
			user.set_password(utils.random_password())
			user.save()

		#find or create role
		role, created = models.UserRole.objects.get_or_create(uuid=client_role.get('uuid'))
		if not created:
			if role.device_date > client_role_date:
				continue

		#set role data
		role.role = client_role.get('role')
		role.board = board
		role.user = user
		role.device_date = client_role_date
		role.deleted = client_role.get('deleted',False)
		role.save()

		#set created in uuid lookup. this is after role.save so the uuid is pouplated
		if created:
			created_object_uuids['user_roles'].append(role.uuid)

	#go through behaviors
	client_behaviors = data.get('behaviors',[])
	for client_behavior in client_behaviors:
		client_behavior_date = json_utils.date_fromstring(client_behavior.get('updated_date'))

		#get board for behavior.board
		try:
			board_dict = client_behavior.get('board')
			board = models.Board.objects.get(uuid=board_dict.get("uuid"))
		except:
			return json_response_error("Client sync error, Board with uuid (%s) for behavior not found on server." % (client_behavior.get('uuid')))

		#get or create behavior
		behavior,created = models.Behavior.objects.get_or_create(uuid=client_behavior.get('uuid'))
		if not created:
			if behavior.device_date > client_behavior_date:
				continue

		#set behavior data
		behavior.board = board
		behavior.title = client_behavior.get('title')
		behavior.note = client_behavior.get('note')
		behavior.device_date = client_behavior_date
		behavior.deleted = client_behavior.get('deleted',False)
		behavior.save()

		#set created for lookup
		if created:
			created_object_uuids['behaviors'].append(behavior.uuid)

	#go through smiles
	client_smiles = data.get('smiles',[])
	for client_smile in client_smiles:
		smile_date = json_utils.date_fromstring(client_smile.get('updated_date'))
		
		#get user for smile.user
		try:
			user_dict = client_smile.get('user')
			user = User.objects.get(username=user_dict.get('username'))
		except:
			return json_response_error("Client sync error, User with username(%s) for smile not found on server." % (user_dict.get('user')))
		
		#get board for smile.board
		try:
			board_dict = client_smile.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, Board with uuid(%s) for smile not found on server." % (board_dict.get('uuid')))
		
		#get behavior for smile.behavior
		try:
			behavior_dict = client_smile.get('behavior')
			behavior = models.Behavior.objects.get(uuid=behavior_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, Behavior with uuid(%s) for smile not found on server." % (behavior_dict.get('uuid')))

		#get or create smile
		smile,created = models.Smile.objects.get_or_create(uuid=client_smile.get('uuid'))
		if not created:
			if smile.device_date > smile_date:
				continue

		#set smile data
		smile.user = user
		smile.board = board
		smile.behavior = behavior
		smile.deleted = client_smile.get('deleted',False)
		smile.device_date = smile_date
		smile.collected = client_smile.get('collected')
		smile.note = client_smile.get('note', '')
		smile.save()

		#set created uuid lookup. after save so uuid is available
		if created:
			created_object_uuids['smiles'].append(smile.uuid)

	#go through frowns
	client_frowns = data.get('frowns',[])
	for client_frown in client_frowns:
		client_frown_date = json_utils.date_fromstring(client_frown.get('updated_date'))
		
		#get user for frown.user
		try:
			user_dict = client_frown.get('user')
			user = User.objects.get(username=user_dict.get('username'))
		except:
			return json_response_error("Client sync error, User with username(%s) for frown not found on server." % (user_dict.get('username')))
		
		#get board for frown.board
		try:
			board_dict = client_frown.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, Board with uuid(%s) for frown not found on server." % (board_dict.get('uuid')))
		
		#get behavior for frown.behavior
		try:
			behavior_dict = client_frown.get('behavior')
			behavior = models.Behavior.objects.get(uuid=behavior_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, Behavior with uuid(%s) for frown not found on server." % (behavior_dict.get('uuid')))

		#get or create frown
		frown,created = models.Frown.objects.get_or_create(uuid=client_frown.get('uuid'))
		if not created:
			if frown.device_date > client_frown_date:
				continue

		#set frown data
		frown.user = user
		frown.board = board
		frown.behavior = behavior
		frown.deleted = client_frown.get('deleted',False)
		frown.device_date = client_frown_date
		frown.note = client_smile.get('note', '')
		frown.save()

		#set created in lookup
		if created:
			created_object_uuids['frowns'].append(frown.uuid)

	#go through rewards
	client_rewards = data.get('rewards',[])
	for client_reward in client_rewards:
		client_reward_date = json_utils.date_fromstring(client_reward.get('updated_date'))

		#get board for reward.board
		try:
			board_dict = client_reward.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			return json_response_error("Client sync error, board with uuid(%s) for reward not found on server." % (board_dict.get('uuid')))

		#get or create reward
		reward,created = models.Reward.objects.get_or_create(uuid=client_reward.get('uuid'))
		if not created:
			if reward.device_date > client_reward_date:
				continue

		#set reward data
		reward.board = board
		reward.deleted = client_reward.get('deleted',False)
		reward.title = client_reward.get('title')
		reward.currency_amount = client_reward.get('currency_amount')
		reward.smile_amount = client_reward.get('smile_amount')
		reward.currency_type = client_reward.get('currency_type')
		reward.device_date = client_reward_date
		reward.save()

		#set created for lookup
		if created:
			created_object_uuids['rewards'].append(reward.uuid)

	#return sync pull for response data
	return sync_pull(request,sync_date=data.get('sync_date',None),created_object_uuids=created_object_uuids)

