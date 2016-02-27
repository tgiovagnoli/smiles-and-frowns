from django.contrib import admin
from predefinedboards import models

class PredefinedBoardAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "description", "behaviors", "uuid", "list_sort", "soft_delete",)
	readonly_fields = ("uuid",)
	list_display = ("title","list_sort","uuid","soft_delete",)
	filter_horizontal = ("behaviors",)

class PredefinedBehaviorAdmin(admin.ModelAdmin):
	save_on_top = True
	list_display = ("title", "positive","uuid","group","soft_delete",)
	fields = ("title", "group", "uuid", "positive", "soft_delete",)
	readonly_fields = ("uuid",)
	
class PredefinedBehaviorGroupAdmin(admin.ModelAdmin):
	save_on_top = True
	fields = ("title", "behaviors", "uuid", "soft_delete",)
	readonly_fields = ("uuid",)
	list_display = ("title","soft_delete",)
	filter_horizontal = ("behaviors",)

admin.site.register(models.PredefinedBoard, PredefinedBoardAdmin)
admin.site.register(models.PredefinedBehavior, PredefinedBehaviorAdmin)
admin.site.register(models.PredefinedBehaviorGroup, PredefinedBehaviorGroupAdmin)