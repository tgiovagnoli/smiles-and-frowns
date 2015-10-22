import uuid
from django.db import models
from django.contrib.auth.models import User
from django.contrib import admin
from django.db.models import Q
from django.core.exceptions import ValidationError
from django.db.models.signals import pre_save, post_save

# base model for all classes that need to synchronize between devices
class SyncModel(models.Model):
	uuid = models.CharField(max_length=64, unique=True)
	created_date = models.DateTimeField(auto_now_add=True)
	updated_date = models.DateTimeField(auto_now=True)
	device_date = models.DateTimeField()
	deleted = models.BooleanField(default=False)
	def save(self, *args, **kwargs):
		if self.uuid == None or self.uuid == "" or len(self.uuid) == 0:
			self.uuid = str(uuid.uuid4())
		super(SyncModel, self).save(*args,**kwargs)
	class Meta:
		abstract = True

PROFILE_ROLE_CHOICES = (
	("owner", "Owner"),
	("parent", "Parent"),
	("guardian", "Guardian"),
	("child", "Child"),
)

GENDER_CHOICES = (
	("male", "Male"),
	("female", "Female")
)

CURRENCY_TYPE_CHOICES = (
	("money", "Money"),
	("time", "Time"),
	("treat", "Treat"),
	("goal", "Goal")
)

class Profile(models.Model):
	"""
	This extends the default django User model through composition with OneToOneField.
	any properties on this model are accessible by the user model like:
	userModelInstance.profile.role
	#http://deathofagremmie.com/2014/05/24/retiring-get-profile-and-auth-profile-module/
	#https://docs.djangoproject.com/en/1.8/topics/auth/customizing/
	"""
	user = models.OneToOneField(User)
	gender = models.CharField(max_length=64, choices=GENDER_CHOICES, blank=True, default=None)
	age = models.CharField(max_length=3, default=None, blank=True)
	def __unicode__(self):
		return self.user.username

def create_user_profile(sender,instance,created,**kwargs):
	"""creates a new user profile when a django user model is saved."""
	if created:
		profile, created = Profile.objects.get_or_create(user=instance)
post_save.connect(create_user_profile, sender=User)

class Board(SyncModel):
	title = models.CharField(max_length=128)
	owner = models.ForeignKey(User)
	in_app_purchase_id = models.CharField(max_length=128, blank=True, default=None)
	edit_count = models.IntegerField(default=0)

	@property
	def users(self):
		return UserRole.objects.filter(board=self)
	@property
	def behaviors(self):
		return Behavior.objects.filter(board=self)
	@property
	def rewards(self):
		return Reward.objects.filter(board=self)
	@property
	def smiles(self):
		return Smile.objects.filter(board=self)
	@property
	def frowns(self):
		return Frown.objects.filter(board=self)
	@property
	def invites(self):
		return Invite.objects.filter(board=self)

	def save(self, *args, **kwargs):
		self.edit_count = self.edit_count + 1
		super(Board, self).save(*args,**kwargs)
	def __unicode__(self):
		return self.title

class UserRole(SyncModel):
	user = models.OneToOneField(User)
	role = models.CharField(max_length=64, choices=PROFILE_ROLE_CHOICES, default="child")
	board = models.ForeignKey(Board)
	def __unicode__(self):
		return self.role + " - " + self.user.username

class Behavior(SyncModel):
	title = models.CharField(max_length=128)
	note = models.CharField(max_length=256, blank=True, default=None)
	board = models.ForeignKey(Board)
	def save(self, *args, **kwargs):
		self.board.edit_count = self.board.edit_count + 1
		self.board.save()
		super(Behavior, self).save(*args,**kwargs)
	def __unicode__(self):
		return self.title

class Reward(SyncModel):
	board = models.ForeignKey(Board)
	title = models.CharField(max_length=128)
	currency_amount = models.FloatField()
	smile_amount = models.FloatField()
	currency_type = models.CharField(max_length=64, choices=CURRENCY_TYPE_CHOICES, default="money")
	def save(self, *args, **kwargs):
		self.board.edit_count = self.board.edit_count + 1
		self.board.save()
		super(Reward, self).save(*args,**kwargs)
	def __unicode__(self):
		return self.title

class Smile(SyncModel):
	user = models.OneToOneField(User)
	board = models.ForeignKey(Board)
	behavior = models.ForeignKey(Behavior)
	collected = models.BooleanField(default=False)
	def save(self, *args, **kwargs):
		self.board.edit_count = self.board.edit_count + 1
		self.board.save()
		super(Smile, self).save(*args,**kwargs)
	def __unicode__(self):
		return self.board.title

class Frown(SyncModel):
	user = models.OneToOneField(User)
	board = models.ForeignKey(Board)
	behavior = models.ForeignKey(Behavior)
	def save(self, *args, **kwargs):
		self.board.edit_count = self.board.edit_count + 1
		self.board.save()
		super(Frown, self).save(*args,**kwargs)
	def __unicode__(self):
		return self.board.title


class Invite(models.Model):
	board = models.ForeignKey(Board)
	user = models.ForeignKey(User, null=True, blank=True)
	code = models.CharField(max_length=64)
	def __unicode__(self):
		return self.board.title

class PredefinedBoard(models.Model):
	board = models.ForeignKey(Board)
	def __unicode__(self):
		return self.board.title
