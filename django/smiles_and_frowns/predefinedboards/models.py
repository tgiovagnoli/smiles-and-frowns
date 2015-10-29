from django.db import models
import uuid

class PredefinedBoardBehavior(models.Model):
	title = models.CharField(max_length=128)
	uuid = models.CharField(max_length=64)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBoardBehavior, self).save(*args,**kwargs)

class PredefinedBoard(models.Model):
	title = models.CharField(max_length=128)
	uuid = models.CharField(max_length=64)
	behaviors = models.ManyToManyField(PredefinedBoardBehavior)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBoard, self).save(*args,**kwargs)

class PredefinedBoardBehaviorGroup(models.Model):
	title = models.CharField(max_length=128)
	uuid = models.CharField(max_length=64)
	behaviors = models.ManyToManyField(PredefinedBoardBehavior)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBoardBehaviorGroup, self).save(*args,**kwargs)
