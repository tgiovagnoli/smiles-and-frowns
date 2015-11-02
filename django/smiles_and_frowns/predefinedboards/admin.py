from django.contrib import admin
from predefinedboards import models


class PredefinedBoardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "behaviors", "uuid")
	readonly_fields = ("uuid",)
	list_display = ("title",)
	filter_horizontal = ("behaviors",)

class PredefinedBehaviorAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "uuid")
	readonly_fields = ("uuid",)
	list_display = ("title",)

class PredefinedBehaviorGroupAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "behaviors", "uuid")
	readonly_fields = ("uuid",)
	list_display = ("title",)
	filter_horizontal = ("behaviors",)

admin.site.register(models.PredefinedBoard, PredefinedBoardAdmin)
admin.site.register(models.PredefinedBehavior, PredefinedBehaviorAdmin)
admin.site.register(models.PredefinedBehaviorGroup, PredefinedBehaviorGroupAdmin)