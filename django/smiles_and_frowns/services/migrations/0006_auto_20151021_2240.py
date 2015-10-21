# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('services', '0005_auto_20151021_2235'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='board',
            name='users',
        ),
        migrations.AddField(
            model_name='board',
            name='owner',
            field=models.ForeignKey(default=1, to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='userrole',
            name='board',
            field=models.ForeignKey(default=1, to='services.Board'),
            preserve_default=False,
        ),
    ]
