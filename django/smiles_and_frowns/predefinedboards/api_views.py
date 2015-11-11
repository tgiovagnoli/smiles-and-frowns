import json
from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from predefinedboards import models

def json_response(response_data):
	return HttpResponse(json.dumps(response_data, indent=4), content_type="application/json")


def serialize_boards(boards):
	boards_info = []
	for board in boards:
		boards_info.append({
			"title": board.title,
			"uuid": board.uuid,
			"id": board.id,
			"behaviors": serialize_behaviors(board.behaviors.all(), uuid_only=True)
		})
	return boards_info;

def serialize_behaviors(behaviors, uuid_only=False):
	behaviors_info = []
	for behavior in behaviors:
		if uuid_only:
			behaviors_info.append({
				"uuid": behavior.uuid,
			})
		else:
			behaviors_info.append({
				"title": behavior.title,
				"uuid": behavior.uuid,
				"id": behavior.id,
				"positive": behavior.positive,
			})
	return behaviors_info;

def serialize_behavior_groups(behavior_groups):
	group_info = []
	for group in behavior_groups:
		group_info.append({
			"title": group.title,
			"uuid": group.uuid,
			"id": group.id,
			"behaviors": serialize_behaviors(group.behaviors.all(), uuid_only=True)
		})
	return group_info;

def sync_boards(request):
	boards = models.PredefinedBoard.objects.all()
	behaviors = models.PredefinedBehavior.objects.all()
	behavior_groups = models.PredefinedBehaviorGroup.objects.all()
	info_dict = {
		"boards": serialize_boards(boards),
		"behaviors": serialize_behaviors(behaviors),
		"behavior_groups": serialize_behavior_groups(behavior_groups)
	}
	return json_response(info_dict)