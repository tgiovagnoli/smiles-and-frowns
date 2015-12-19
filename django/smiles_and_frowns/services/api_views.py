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
	return HttpResponse(json.dumps(response_data), content_type="application/json")

def json_response_error(error_message):
	return HttpResponse(json.dumps({'error':error_message}), content_type="application/json")

def login_required_response():
	return json_response({"error": "login required"})

@csrf_exempt
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
		output = json_utils.user_info_dictionary(user,request)
		return json_response(output)
	
	return json_response_error("user not found")

@csrf_exempt
def upload_temp_profile_image(request):
	'''
	@param image
	'''
	#post only
	if request.method != "POST":
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated():
		return login_required_response()

	#get params
	image = request.FILES.get('image',None)

	if not image:
		return json_response_error("image required")

	tmp = models.TempProfileImage(image=image)
	tmp.save()

	url = request.build_absolute_uri(tmp.image.url)

	return json_response( {'uuid':tmp.uuid, 'url':url} )

@csrf_exempt
def user_update_profile_image(request):
	'''
	@param user_uuid
	@param image
	'''
	#post only
	if request.method != "POST":
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated():
		return login_required_response()

	#get params
	username = request.POST.get('username')
	image = request.FILES.get('image',None)
	
	if not image:
		return json_response_error("image required")

	user = None
	try:
		user = models.User.objects.get(username=username)
	except:
		return json_response_error("User not found")

	#check permission
	is_permitted = False
	if user == request.user:
		is_permitted = True

	boards = []
	all_boards = models.Board.objects.filter(owner=request.user).all()
	for board in all_boards:
		for user_role in board.users:
			if user_role.user == user:
				is_permitted = True
	if is_permitted == False:
		return json_response_error("Not permitted")
	

	#set image
	user.profile.image = image
	user.profile.save()

	#update the device_date for all the user roles. this triggers a sync for anyone else on next sync
	roles = models.UserRole.objects.filter(user=user)
	device_date = UTC.localize(datetime.utcnow())
	for role in roles:
		role.device_date = device_date
		role.save()

	return json_response( json_utils.user_info_dictionary(user,request) )

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
	user.set_password(new_password)
	user.save()

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
	new_user = None
	try:
		new_user = User(email=email,username=username,first_name=firstname,last_name=lastname,password=make_password(password))
		new_user.save()
		if age: new_user.profile.age = age
		if gender: new_user.profile.gender = gender
		new_user.profile.save()
	except Exception as e:
		return json_response_error('error creating user %s' % str(e))

	#try and authenticate user
	new_user2 = None
	try: 
		new_user2 = authenticate(username=username,password=password)
		login(request,new_user2)
	except Exception as e:
		print "ERROR"
		return json_response_error(str(e))

	#return new user
	output = json_utils.user_info_dictionary(new_user,request)
	return json_response(output)

@csrf_exempt
def user_update(request):
	'''
	@param first_name
	@param last_name
	@param email
	@param age
	@param gender
	@param password
	@param password_confirm
	'''

	#check post
	if request.method != "POST":
		return json_response_error("method not allowed")

	#check auth
	if not request.user.is_authenticated():
		return login_required_response()

	email = request.POST.get('email',None)
	password = request.POST.get('password',None)
	password_confirm = request.POST.get('password_confirm',None)
	firstname = request.POST.get('first_name',None)
	lastname = request.POST.get('last_name',None)
	age = request.POST.get('age',None)
	gender = request.POST.get('gender',None)

	#lookup existing user.
	user = None
	try:
		user = User.objects.get(email=email)
	except Exception as e:
		return json_response_error(str(e))

	#check the requesting user's username against db record
	if user and user.username != request.user.username:
		return json_response_error("Cannot update user record, email address is already used")

	if email:
		request.user.email = email

	if firstname:
		request.user.first_name = firstname

	if lastname:
		request.user.last_name = lastname

	if age:
		request.user.profile.age = age

	if gender:
		request.user.profile.gender = gender

	request.user.save()
	request.user.profile.save()
	
	#update the device_date for all the user roles. this triggers a sync for anyone else on next sync
	roles = models.UserRole.objects.filter(user=request.user)
	device_date = UTC.localize( datetime.utcnow() )
	for role in roles:
		role.device_date = device_date
		role.save()

	if password and password_confirm and password == password_confirm:
		user = request.user
		
		#set password
		request.user.set_password(password)
		request.user.save()

		#try and authenticate user
		try: 
			new_user = authenticate(username=user.username,password=password)
			login(request,new_user)
		except Exception as e:
			return json_response_error(str(e))
	
	data = json_utils.user_info_dictionary(request.user,request)
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
	data = json_utils.user_info_dictionary(user,request)
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
	data = json_utils.user_info_dictionary(request.user,request)
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
	user_role,created = models.UserRole.objects.get_or_create(board=invite.board,user=request.user)
	user_role.role = invite.role
	user_role.save()

	#get return data
	output = sync_data_for_board(invite.board,request)

	#append invite to response output
	output['invite'] = json_utils.invite_info_dictionary(invite)

	#delete invite
	invite.delete()

	#returns all new data
	return json_response(output)

@csrf_exempt
def invite_delete(request):
	'''
	@param code
	'''
	#check auth
	if not request.user.is_authenticated():
		return login_required_response()
	code = request.POST.get('code',None)
	if not code:
		return json_response_error("Invite code required")
	invites = models.Invite.objects.filter(code=code)
	for invite in invites:
		invite.delete()
	return json_response({})

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
	invitee_user = None
	try:
		invitee_user = User.objects.get(email=invitee_email)
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
	invite,created = models.Invite.objects.get_or_create(user=invitee_user,invitee_email=invitee_email,board=board,role=role)

	#new invite, set new code
	if created:
		invite.sender = inviter_user
		invite.invitee_firstname = invitee_firstname
		invite.invitee_lastname = invitee_lastname
		invite.invitee_email = invitee_email
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
	template_plain = loader.get_template("invite_with_code.txt")
	template_html = loader.get_template("invite_with_code.html")
	
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
	received_invites = models.Invite.objects.filter(user=request.user)
	sent_invites = models.Invite.objects.filter(sender=request.user)
	output = {}
	output['received_invites'] = json_utils.invite_info_dictionary_collection(received_invites)
	output['sent_invites'] = json_utils.invite_info_dictionary_collection(sent_invites)
	return json_response(output)

def sync_data_for_board(board,request):
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
	output['boards'] = [json_utils.board_info_dictionary(board,request)]
	output['behaviors'] = json_utils.behavior_info_dictionary_collection(behaviors)
	output['smiles'] = json_utils.smile_info_dictionary_collection(smiles)
	output['frowns'] = json_utils.frown_info_dictionary_collection(frowns)
	output['rewards'] = json_utils.reward_info_dictionary_collection(rewards)
	output['user_roles'] = json_utils.user_role_info_dictionary_collection(user_roles,request)

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
	user_roles = models.UserRole.objects.filter(~Q(uuid__in=created_object_uuids['user_roles']),board__in=boards,device_date__gt=sync_date)

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
	output['boards'] = json_utils.board_info_dictionary_collection(boards,request)
	output['behaviors'] = json_utils.behavior_info_dictionary_collection(behaviors)
	output['smiles'] = json_utils.smile_info_dictionary_collection(smiles)
	output['frowns'] = json_utils.frown_info_dictionary_collection(frowns)
	output['rewards'] = json_utils.reward_info_dictionary_collection(rewards)
	output['user_roles'] = json_utils.user_role_info_dictionary_collection(user_roles,request)

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
		
		#check if deleted
		if client_board.get('deleted',False):
			board.deleted = True
			board.save()

		#board wasn't created, check date and predefinied.
		if not created:

			#board is newerin database than what the client sent or deleted. ignore it.
			if board.device_date > board_client_date or board.deleted:
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
		board = None
		try:
			board_dict = client_role.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			pass
		
		#get provided user info about role
		userinfo = client_role.get('user', None)
		
		#find or create role
		role, role_created = models.UserRole.objects.get_or_create(uuid=client_role.get('uuid'))
		if not role_created:

			#check if deleted.
			if client_role.get('deleted',False):
				if not role.deleted:
					role.deleted = True
					role.save()

			#check if dates are newer on db
			if role.device_date > client_role_date or role.deleted:
				continue

		#if not user info, just ignore and continue.
		if not userinfo:
			continue
		
		#create account if it's a child, other users signup through the normal signup process
		user = None
		if role.role == "child":
			#try and find existing user in DB
			user, user_created = User.objects.get_or_create(username=userinfo.get('username'))
			
			profile_image = None
			if user_created:
				user.email = ""

				#look for tmp profile image
				tmp_uuid = userinfo.get('tmp_profile_image_uuid',None)
				if tmp_uuid:
					try:
						profile_image = models.TempProfileImage.objects.get(uuid=tmp_uuid)
					except:
						pass

			user.first_name = userinfo.get('first_name','')
			user.last_name = userinfo.get('last_name','')
			user.save()
			
			if profile_image:
				user.profile.image = profile_image.image
				profile_image.delete()

			user.profile.age = userinfo.get('age','')
			user.profile.gender = userinfo.get('gender','')
			user.profile.save()
			

		#set role data
		if role_created:
			role.board = board
			role.user = user
			
		role.role = client_role.get('role')
		role.device_date = client_role_date
		role.deleted = client_role.get('deleted',False)
		role.save()

		#set created in uuid lookup. this is after role.save so the uuid is pouplated
		if role_created:
			created_object_uuids['user_roles'].append(role.uuid)

	#go through behaviors
	client_behaviors = data.get('behaviors',[])
	for client_behavior in client_behaviors:
		client_behavior_date = json_utils.date_fromstring(client_behavior.get('updated_date'))
		
		#get board for behavior.board
		board = None
		board_dict = client_behavior.get('board')
		if board_dict:
			try:
				board = models.Board.objects.get(uuid=board_dict.get('uuid'))
			except:
				pass

		#get or create behavior
		behavior,created = models.Behavior.objects.get_or_create(uuid=client_behavior.get('uuid'))
		if not created:
			
			#check if deleted
			if client_behavior.get('deleted',False):
				if not behavior.deleted:
					behavior.deleted = True
					behavior.save()

			#check if date is newer in db.
			if behavior.device_date > client_behavior_date or behavior.deleted:
				continue

		#set behavior data
		behavior.board = board
		behavior.title = client_behavior.get('title')
		behavior.note = client_behavior.get('note')
		behavior.device_date = client_behavior_date
		behavior.deleted = client_behavior.get('deleted',False)
		behavior.positive = client_behavior.get('positive',True)
		behavior.save()

		#set created for lookup
		if created:
			created_object_uuids['behaviors'].append(behavior.uuid)

	#go through smiles
	client_smiles = data.get('smiles',[])
	for client_smile in client_smiles:
		smile_date = json_utils.date_fromstring(client_smile.get('updated_date'))
		
		#get user for smile.user
		user = None
		try:
			user_dict = client_smile.get('user')
			user = User.objects.get(username=user_dict.get('username'))
		except:
			pass

		creator = None
		try:
			creator_dict = client_smile.get('creator')
			creator = User.objects.get(username=creator_dict.get('username'))
		except:
			pass
		
		#get board for smile.board
		board = None
		try:
			board_dict = client_smile.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			pass
		
		#get behavior for smile.behavior
		behavior = None
		try:
			behavior_dict = client_smile.get('behavior')
			behavior = models.Behavior.objects.get(uuid=behavior_dict.get('uuid'))
		except:
			pass

		#get or create smile
		smile,created = models.Smile.objects.get_or_create(uuid=client_smile.get('uuid'))
		if not created:

			#check if deleted
			if client_smile.get('deleted',False):
				if not smile.deleted:
					smile.deleted = True
					smile.save()

			#check if date is newer in db.
			if smile.device_date > smile_date or smile.deleted:
				continue

		#set smile data
		smile.user = user
		smile.creator = creator
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
		user = None
		try:
			user_dict = client_frown.get('user')
			user = User.objects.get(username=user_dict.get('username'))
		except:
			pass

		#get creator
		creator = None
		try:
			creator_dict = client_frown.get('creator')
			creator = User.objects.get(username=creator_dict.get('username'))
		except:
			pass
		
		#get board for frown.board
		board = None
		try:
			board_dict = client_frown.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			pass
		
		#get behavior for frown.behavior
		behavior = None
		try:
			behavior_dict = client_frown.get('behavior')
			behavior = models.Behavior.objects.get(uuid=behavior_dict.get('uuid'))
		except:
			pass

		#get or create frown
		frown,created = models.Frown.objects.get_or_create(uuid=client_frown.get('uuid'))
		if not created:

			#check if deleted
			if client_frown.get('deleted',False):
				if not frown.deleted:
					frown.deleted = True
					frown.save()

			#check if date is newer in db.
			if frown.device_date > client_frown_date or frown.deleted:
				continue

		#set frown data
		frown.user = user
		frown.creator = creator
		frown.board = board
		frown.behavior = behavior
		frown.deleted = client_frown.get('deleted',False)
		frown.device_date = client_frown_date
		frown.note = client_frown.get('note', '')
		frown.save()

		#set created in lookup
		if created:
			created_object_uuids['frowns'].append(frown.uuid)

	#go through rewards
	client_rewards = data.get('rewards',[])
	for client_reward in client_rewards:
		client_reward_date = json_utils.date_fromstring(client_reward.get('updated_date'))

		#get board for reward.board
		board = None
		try:
			board_dict = client_reward.get('board')
			board = models.Board.objects.get(uuid=board_dict.get('uuid'))
		except:
			pass

		#get or create reward
		reward,created = models.Reward.objects.get_or_create(uuid=client_reward.get('uuid'))
		if not created:

			#check deleted
			if client_reward.get('deleted',False):
				if not reward.deleted:
					reward.deleted = True
					reward.save()

			#check if date is newer in db.
			if reward.device_date > client_reward_date or reward.deleted:
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

