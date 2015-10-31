from django.db import models
import datetime
import json
from services import models
from django.core import serializers
from pytz import UTC

def datestring(datetimeobj):
	return datetimeobj.strftime("%Y-%m-%dT%H:%M:%SZ")

def date_fromstring(datestring):
	return UTC.localize(datetime.datetime.strptime(datestring,"%Y-%m-%dT%H:%M:%SZ"))

def append_sync_info(sync_model_instance, info_dict):
	info_dict["created_date"] = datestring(sync_model_instance.created_date)
	info_dict["updated_date"] = datestring(sync_model_instance.updated_date)
	info_dict["device_date"] = datestring(sync_model_instance.device_date)
	info_dict["uuid"] = sync_model_instance.uuid
	info_dict["deleted"] = sync_model_instance.deleted

def board_info_dictionary_collection(boards, with_users=False, with_behaviors=False, with_rewards=False, with_smiles=False, with_frowns=False, with_invites=False):
	board_data = []
	for board in boards:
		board_data.append(board_info_dictionary(board, with_users=with_users, with_behaviors=with_behaviors, with_rewards=with_rewards, with_smiles=with_smiles, with_frowns=with_frowns, with_invites=with_invites))
	return board_data

def board_info_dictionary(board, with_users=False, with_behaviors=False, with_rewards=False, with_smiles=False, with_frowns=False, with_invites=False):
	board_data = {
		"title": board.title,
		"id": board.id
	}
	
	if board.owner:
		board_data["owner"] = {
			"username": board.owner.username,
			"first_name": board.owner.first_name,
			"last_name": board.owner.last_name,
			"email": board.owner.email,
		}

		if board.owner.profile.age:
			board_data["age"] = int(board.owner.profile.age)
		
		if board.owner.profile.gender:
			board_data["gender"] = board.owner.profile.gender


	append_sync_info(board, board_data)
	if with_users:
		board_data["users"] = user_role_info_dictionary_collection(board.users, with_users=True)
	if with_behaviors:
		board_data["behaviors"] = behavior_info_dictionary_collection(board.behaviors)
	if with_rewards:
		board_data["rewards"] = reward_info_dictionary_collection(board.rewards)
	if with_smiles:
		board_data["smiles"] = smile_info_dictionary_collection(board.smiles)
	if with_frowns:
		board_data["frowns"] = frown_info_dictionary_collection(board.frowns)
	if with_invites:
		board_data["invites"] = invite_info_dictionary_collection(board.invites)
	return board_data

def user_role_info_dictionary_collection(user_roles, with_users=False, with_boards=False):
	user_roles_data = []
	for user_role in user_roles:
		user_roles_data.append( user_role_info_dictionary(user_role, with_user=with_users, with_board=with_boards) )
	return user_roles_data

def user_role_info_dictionary(user_role, with_user=False, with_board=False):
	user_role_data = {
		"role": user_role.role,
		"id": user_role.id
	}
	append_sync_info(user_role, user_role_data)

	if user_role.board:
		user_role_data['board'] = {'uuid':user_role.board.uuid}

	if with_board and user_role.board:
		user_role_data["board"] =  board_info_dictionary(user_role.board)
	
	if with_user and user_role.user:
		user_role_data["user"] =  user_info_dictionary(user_role.user)
	
	return user_role_data

def user_info_dictionary(user):
	user_data = {
		"username": user.username,
		"first_name":user.first_name,
		"last_name":user.last_name,
		"email":user.email,
		"id": user.id
	}
	if user.profile.gender:
		user_data["gender"] = user.profile.gender
	if user.profile.age:
		user_data['age'] = int(user.profile.age)
	return user_data

def behavior_info_dictionary_collection(behaviors, with_boards=False):
	behavior_data = []
	for behavior in behaviors:
		behavior_data.append(behavior_info_dictionary(behavior, with_board=with_boards))
	return behavior_data

def behavior_info_dictionary(behavior, with_board=False):
	behavior_data = {
		"title": behavior.title,
		"note": behavior.note,
		"id": behavior.id
	}
	append_sync_info(behavior, behavior_data)
	
	if behavior.board:
		behavior_data['board'] = {'uuid':behavior.board.uuid}

	
	if with_board:
		behavior_data["board"] = board_info_dictionary(behavior.board)
	
	return behavior_data

def reward_info_dictionary_collection(rewards, with_boards=False):
	reward_data = []
	for reward in rewards:
		reward_data.append(reward_info_dictionary(reward, with_board=with_boards))
	return reward_data

def reward_info_dictionary(reward, with_board=False):
	reward_data = {
		"title": reward.title,
		"currency_amount": reward.currency_amount,
		"smile_amount": reward.smile_amount,
		"currency_type": reward.currency_type,
		"id": reward.id
	}
	append_sync_info(reward, reward_data)

	if reward.board:
		reward_data['board'] = {'uuid':reward.board.uuid}

	if with_board:
		reward_data["board"] = board_info_dictionary(reward.board)

	return reward_data

def smile_info_dictionary_collection(smiles, with_boards=False, with_users=False):
	smiles_data = []
	for smile in smiles:
		smiles_data.append(smile_info_dictionary(smile, with_board=with_boards, with_user=with_users))
	return smiles_data

def smile_info_dictionary(smile, with_board=False, with_user=False):
	smile_data = {
		"behavior": {"uuid": smile.behavior.uuid},
		"id": smile.id,
		"collected": smile.collected,
		"note": smile.note
	}
	append_sync_info(smile, smile_data)
	
	if smile.board:
		smile_data['board'] = {'uuid':smile.board.uuid}

	if with_board:
		smile_data["board"] = board_info_dictionary(smile.board)
	
	if with_user:
		smile_data["user"] = user_info_dictionary(smile.user)
	else:
		smile_data["user"] = {"username": smile.user.username}

	return smile_data

def frown_info_dictionary_collection(frowns, with_boards=False, with_users=False):
	frowns_data = []
	for frown in frowns:
		frowns_data.append(frown_info_dictionary(frown, with_board=with_boards, with_user=with_users))
	return frowns_data

def frown_info_dictionary(frown, with_board=False, with_user=False):
	frown_data = {
		"behavior": {"uuid": frown.behavior.uuid},
		"id": frown.id,
		"note": frown.note
	}
	append_sync_info(frown, frown_data)
	
	if frown.board:
		frown_data['board'] = {'uuid':frown.board.uuid}

	if with_board:
		frown_data["board"] = board_info_dictionary(frown.board)
	
	if with_user:
		frown_data["user"] = user_info_dictionary(frown.user)
	else:
		frown_data["user"] = {"username": frown.user.username}
	
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
