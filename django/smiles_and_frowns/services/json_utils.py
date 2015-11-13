from django.db import models
import datetime,os
import json
from services import models
from django.core import serializers
from pytz import UTC
from smiles_and_frowns import settings

def datestring(datetimeobj):
	return datetimeobj.strftime("%Y-%m-%dT%H:%M:%SZ")

def date_fromstring(datestring):
	return UTC.localize(datetime.datetime.strptime(datestring,"%Y-%m-%dT%H:%M:%SZ"))

def append_sync_info(sync_model_instance,info_dict):
	info_dict["created_date"] = datestring(sync_model_instance.created_date)
	info_dict["updated_date"] = datestring(sync_model_instance.updated_date)
	info_dict["device_date"] = datestring(sync_model_instance.device_date)
	info_dict["uuid"] = sync_model_instance.uuid
	info_dict["deleted"] = sync_model_instance.deleted

def board_info_dictionary_collection(boards):
	board_data = []
	for board in boards:
		board_data.append(board_info_dictionary(board))
	return board_data

def board_info_dictionary(board):
	board_data = {
		"title": board.title,
		"id": board.id
	}
	if board.owner: board_data["owner"] = user_info_dictionary(board.owner)
	append_sync_info(board, board_data)
	return board_data

def user_role_info_dictionary_collection(user_roles):
	user_roles_data = []
	for user_role in user_roles:
		user_roles_data.append(user_role_info_dictionary(user_role))
	return user_roles_data

def user_role_info_dictionary(user_role):
	user_role_data = {
		"role": user_role.role,
		"id": user_role.id
	}
	append_sync_info(user_role, user_role_data)
	if user_role.board: user_role_data['board'] = {'uuid':user_role.board.uuid}
	if user_role.user: user_role_data["user"] =  user_info_dictionary(user_role.user)
	return user_role_data

def user_info_dictionary(user):
	user_data = {
		"username": user.username,
		"first_name":user.first_name,
		"last_name":user.last_name,
		"email":user.email,
		"id": user.id
	}
	if user.profile.gender: user_data["gender"] = user.profile.gender
	if user.profile.age: user_data['age'] = int(user.profile.age)
	if user.profile.image:
		user_data['image'] = settings.MEDIA_ABS_URL + user.profile.image.url
	return user_data

def behavior_info_dictionary_collection(behaviors):
	behavior_data = []
	for behavior in behaviors:
		behavior_data.append(behavior_info_dictionary(behavior))
	return behavior_data

def behavior_info_dictionary(behavior):
	behavior_data = {
		"title": behavior.title,
		"note": behavior.note,
		"id": behavior.id,
		"positive": behavior.positive,
	}
	append_sync_info(behavior, behavior_data)
	if behavior.board: behavior_data['board'] = {'uuid':behavior.board.uuid}
	return behavior_data

def reward_info_dictionary_collection(rewards):
	reward_data = []
	for reward in rewards:
		reward_data.append(reward_info_dictionary(reward))
	return reward_data

def reward_info_dictionary(reward):
	reward_data = {
		"title": reward.title,
		"currency_amount": reward.currency_amount,
		"smile_amount": reward.smile_amount,
		"currency_type": reward.currency_type,
		"id": reward.id
	}
	append_sync_info(reward, reward_data)
	if reward.board: reward_data['board'] = {'uuid':reward.board.uuid}
	return reward_data

def smile_info_dictionary_collection(smiles):
	smiles_data = []
	for smile in smiles:
		smiles_data.append(smile_info_dictionary(smile))
	return smiles_data

def smile_info_dictionary(smile):
	smile_data = {
		"id": smile.id,
		"collected": smile.collected,
		"note": smile.note
	}
	append_sync_info(smile, smile_data)
	if smile.behavior: smile_data["behavior"] = {"uuid": smile.behavior.uuid}
	if smile.board: smile_data['board'] = {'uuid':smile.board.uuid}
	if smile.user: smile_data["user"] = {"username": smile.user.username}
	if smile.creator: smile_data["creator"] = {"username": smile.creator.username}
	return smile_data

def frown_info_dictionary_collection(frowns):
	frowns_data = []
	for frown in frowns:
		frowns_data.append(frown_info_dictionary(frown))
	return frowns_data

def frown_info_dictionary(frown):
	frown_data = {
		"id": frown.id,
		"note": frown.note
	}
	append_sync_info(frown, frown_data)
	if frown.behavior: frown_data["behavior"] = {"uuid": frown.behavior.uuid}
	if frown.board: frown_data['board'] = {'uuid':frown.board.uuid}
	if frown.user: frown_data["user"] = {"username":frown.user.username}
	if frown.creator: frown_data["creator"] = {"username": frown.creator.username}
	return frown_data

def invite_info_dictionary_collection(invites):
	invite_data = []
	for invite in invites:
		invite_data.append(invite_info_dictionary(invite))
	return invite_data

def invite_info_dictionary(invite):
	invite_data = {
		"uuid":invite.uuid,
		"code": invite.code,
		"board_title": invite.board.title,
		"board_uuid": invite.board.uuid,
		"invitee_firstname":invite.invitee_firstname,
		"invitee_lastname":invite.invitee_lastname,
		"created_date":datestring(invite.created_date),
		"id":invite.id,
	}

	if invite.sender and invite.sender.first_name:
		invite_data['sender_first_name'] = invite.sender.first_name
	else:
		invite_data['sender_first_name'] = 'Someone'
	
	if invite.sender and invite.sender.last_name:
		invite_data['sender_last_name'] = invite.sender.last_name

	return invite_data
