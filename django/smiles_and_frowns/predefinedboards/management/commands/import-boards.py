from django.core.management.base import BaseCommand, CommandError
from optparse import make_option
from predefinedboards import models
import os,shutil,xlrd

class Command(BaseCommand):
	option_list = BaseCommand.option_list + (
		make_option("--xls",action="store",dest="xls",help="XLS(X) File"),
	)

	def handle(self, *args, **options):
		if not options.get("xls",False):
			raise CommandError("--xls option is required")
		xls = options.get('xls')
		wb = xlrd.open_workbook(xls)

		#create groups
		groups = wb.sheet_by_name("GroupTitles")
		for row in range(0,groups.nrows):
			group = groups.cell_value(row,0)
			if group == "Custom":
				continue
			
			#create group
			group_model,created = models.PredefinedBehaviorGroup.objects.get_or_create(title=group)
			group_model.save()

		#create boards / behaviors
		for sheet in wb.sheets():
			if sheet.name == "GroupTitles":
				continue
			
			#create board
			board_name = sheet.name
			board_model,created = models.PredefinedBoard.objects.get_or_create(title=board_name)
			board_model.save()
			
			#create behaviors
			for row in range(1,sheet.nrows):
				smile = sheet.cell_value(row,0)
				frown = sheet.cell_value(row,1)
				group = sheet.cell_value(row,2)

				#there's a row that's empty seperating smiles/frowns.
				if len(group) < 1 or group == "":
					continue
				
				behavior = None

				#get group
				try:
					group_model = models.PredefinedBehaviorGroup.objects.get(title=group)
				except Exception as e:
					print group
					print e

				#create smile
				if len(smile) > 0 and smile != "":
					behavior = models.PredefinedBehavior(title=smile,positive=True)

				#create frown
				elif len(frown) > 0 and frown != "":
					behavior = models.PredefinedBehavior(title=frown,positive=False)
				
				if behavior:
					behavior.save()
					group_model.behaviors.add(behavior)
					board_model.behaviors.add(behavior)
