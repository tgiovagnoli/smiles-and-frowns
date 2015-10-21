# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Behavior',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('title', models.CharField(max_length=128)),
                ('note', models.CharField(max_length=256)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Board',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('title', models.CharField(max_length=128)),
                ('in_app_purchase_id', models.CharField(default=None, max_length=128, blank=True)),
                ('edit_count', models.IntegerField(default=1)),
                ('users', models.ManyToManyField(to=settings.AUTH_USER_MODEL, blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Frown',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('behavior', models.ForeignKey(to='services.Behavior')),
                ('board', models.ForeignKey(to='services.Board')),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Invite',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('code', models.CharField(max_length=64)),
                ('board', models.ForeignKey(to='services.Board')),
                ('user_owner', models.ForeignKey(blank=True, to=settings.AUTH_USER_MODEL, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='PredefinedBoard',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('board', models.ForeignKey(to='services.Board')),
            ],
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('role', models.CharField(default=b'child', max_length=64, choices=[(b'owner', b'Owner'), (b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')])),
                ('gender', models.CharField(default=None, max_length=64, blank=True, choices=[(b'male', b'Male'), (b'female', b'Female')])),
                ('age', models.IntegerField(blank=True)),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Reward',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('description', models.CharField(max_length=128)),
                ('currency_amount', models.FloatField()),
                ('smile_amount', models.FloatField()),
                ('currency_type', models.CharField(default=b'money', max_length=64, choices=[(b'money', b'Money'), (b'time', b'Time'), (b'treat', b'Treat'), (b'goal', b'Goal')])),
                ('board', models.ForeignKey(to='services.Board')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Smile',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('collected', models.BooleanField(default=False)),
                ('behavior', models.ForeignKey(to='services.Behavior')),
                ('board', models.ForeignKey(to='services.Board')),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.AddField(
            model_name='behavior',
            name='board',
            field=models.ForeignKey(to='services.Board'),
        ),
    ]
