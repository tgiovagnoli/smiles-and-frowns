from django.contrib import admin
from services import models

class ProfileAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("user", "gender", "age", "image")
	list_display = ("user", "age")

class UserRoleAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("user", "role", "board")
	list_display = ("user", "role", "board", "device_date", "deleted", "uuid")
	readonly_fields = ("uuid",)

class BoardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "owner", "device_date", "transaction_id", "deleted", "uuid", "predefined_board_uuid")
	list_display = ("title", "created_date","updated_date","device_date",)
	readonly_fields = ('uuid', "owner",'predefined_board_uuid')

class BehaviorAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "title", "note", "device_date", "deleted", "positive", "uuid", "predefined_behavior_uuid")
	list_display = ("title", "board", "positive", "deleted", "uuid", "updated_date")
	readonly_fields = ('uuid','predefined_behavior_uuid',)

class RewardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "title", "currency_amount", "smile_amount", "currency_type", "device_date", "deleted", "uuid")
	list_display = ("title", "board", "updated_date")
	readonly_fields = ('uuid',)

class SmileAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "creator", "behavior", "collected", "device_date", "deleted", "uuid", "note")
	list_display = ("board", "user", "updated_date")
	readonly_fields = ('uuid',)

class SpendableSmileAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "creator", "behavior", "collected", "device_date", "deleted", "uuid", "note")
	list_display = ("board", "user", "updated_date")
	readonly_fields = ('uuid',)

class FrownAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "creator", "behavior", "device_date", "deleted", "uuid", "note")
	list_display = ("board", "user", "updated_date")
	readonly_fields = ('uuid',)

class InviteAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "invitee_firstname","invitee_lastname","invitee_email","sender", "code", "role")
	list_display = ("board", "user")


admin.site.register(models.Profile, ProfileAdmin)
admin.site.register(models.UserRole, UserRoleAdmin)
admin.site.register(models.Board, BoardAdmin)
admin.site.register(models.Behavior, BehaviorAdmin)
admin.site.register(models.Reward, RewardAdmin)
admin.site.register(models.Smile, SmileAdmin)
admin.site.register(models.SpendableSmile, SpendableSmileAdmin)
admin.site.register(models.Frown, FrownAdmin)
admin.site.register(models.Invite, InviteAdmin)
