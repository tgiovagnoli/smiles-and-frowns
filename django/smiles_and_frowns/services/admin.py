from django.contrib import admin
from services import models

class ProfileAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("user", "role", "gender", "age")
	list_display = ("user", "age")

class UserRoleAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("user", "role")
	list_display = ("user", "role")

class BoardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "edit_count", "in_app_purchase_id", "users", "device_date", "deleted", "uuid")
	list_display = ("title", "edit_count", "updated_date")
	readonly_fields = ('uuid',)

class BehaviorAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "title", "note", "device_date", "deleted", "uuid")
	list_display = ("title", "board", "updated_date")
	readonly_fields = ('uuid',)

class RewardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "title", "currency_amount", "smile_amount", "currency_type", "device_date", "deleted", "uuid")
	list_display = ("title", "board", "updated_date")
	readonly_fields = ('uuid',)

class SmileAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "behavior", "collected", "device_date", "deleted", "uuid")
	list_display = ("board", "user", "updated_date")
	readonly_fields = ('uuid',)

class FrownAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "behavior", "device_date", "deleted", "uuid")
	list_display = ("board", "user", "updated_date")
	readonly_fields = ('uuid',)

class InviteAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board", "user", "code")
	list_display = ("board", "user")

class PredefinedBoardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("board",)

admin.site.register(models.Profile, ProfileAdmin)
admin.site.register(models.UserRole, UserRoleAdmin)
admin.site.register(models.Board, BoardAdmin)
admin.site.register(models.Behavior, BehaviorAdmin)
admin.site.register(models.Reward, RewardAdmin)
admin.site.register(models.Smile, SmileAdmin)
admin.site.register(models.Frown, FrownAdmin)
admin.site.register(models.Invite, InviteAdmin)
admin.site.register(models.PredefinedBoard, PredefinedBoardAdmin)

