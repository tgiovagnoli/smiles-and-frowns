from django.db import models
import uuid

class PredefinedBehavior(models.Model):
	title = models.CharField(max_length=128)
	uuid = models.CharField(max_length=64)
	positive = models.BooleanField(default=True)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBehavior, self).save(*args,**kwargs)

class PredefinedBoard(models.Model):
	title = models.CharField(max_length=128)
	description = models.CharField(max_length=2048,default="",blank=True,null=True)
	uuid = models.CharField(max_length=64)
	behaviors = models.ManyToManyField(PredefinedBehavior)
	list_sort = models.PositiveSmallIntegerField(default=0)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBoard, self).save(*args,**kwargs)

class PredefinedBehaviorGroup(models.Model):
	title = models.CharField(max_length=128)
	uuid = models.CharField(max_length=64)
	behaviors = models.ManyToManyField(PredefinedBehavior)
	def __unicode__(self):
		return self.title
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(PredefinedBehaviorGroup, self).save(*args,**kwargs)
