# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('services', '0035_behavior_group'),
    ]

    operations = [
        migrations.CreateModel(
            name='SpendableSmile',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(unique=True, max_length=64)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('updated_date', models.DateTimeField(auto_now=True)),
                ('device_date', models.DateTimeField()),
                ('deleted', models.BooleanField(default=False)),
                ('collected', models.BooleanField(default=False)),
                ('board', models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True)),
                ('creator', models.ForeignKey(related_name='spendablesmile_creator', on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL, null=True)),
                ('user', models.ForeignKey(related_name='spendablesmile_user', on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
