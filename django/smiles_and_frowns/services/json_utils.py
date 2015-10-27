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
	info_dict["device_date"] = datestring(sync_model_instance.updated_date)
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
		"edit_count": board.edit_count
	}
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
	}
	append_sync_info(user_role, user_role_data)
	if with_board:
		user_role_data["board"] =  board_info_dictionary(user_role.board)
	if with_user:
		user_role_data["user"] =  user_info_dictionary(user_role.user)
	return user_role_data

def user_info_dictionary(user):
	user_data = {
		"username": user.username,
		"gender": user.profile.gender,
		"age": int(user.profile.age),
		"first_name":user.first_name,
		"last_name":user.last_name,
		"email":user.email,
	}
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
	}
	append_sync_info(behavior, behavior_data)
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
	}
	append_sync_info(reward, reward_data)
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
	}
	append_sync_info(smile, smile_data)
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
	}
	append_sync_info(frown, frown_data)
	if with_board:
		frown_data["board"] = board_info_dictionary(frown.board)
	else:
		frown_data["board_uuid"] = frown.board.uuid
	if with_user:
		frown_data["user"] = user_info_dictionary(frown.user)
	else:
		frown_data["user"] = {"username": frown.user.username}
	return frown_data

def invite_info_dictionary_collection(invites, with_boards=False, with_users=False):
	invite_data = []
	for invite in invites:
		invite_data.append(invite_info_dictionary(invite, with_board=with_boards, with_user=with_users))
	return invite_data

def invite_info_dictionary(invite, with_board=False, with_user=False):
	invite_data = {
		"code": invite.code,
		"role": invite.role,
	}
	if with_board:
		invite_data["board"] = board_info_dictionary(invite.board)
	else:
		invite_data["board_uuid"] = invite.board.uuid
	if with_user:
		invite_data["user"] = user_info_dictionary(invite.user)
	else:
		invite_data["user_username"] = invite.user.username
	return invite_data
