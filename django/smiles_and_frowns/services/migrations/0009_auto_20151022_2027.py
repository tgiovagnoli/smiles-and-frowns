# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0008_auto_20151022_1922'),
    ]

    operations = [
        migrations.AlterField(
            model_name='board',
            name='transaction_id',
            field=models.CharField(default=b'', max_length=128, blank=True),
        ),
        migrations.AlterField(
            model_name='profile',
            name='age',
            field=models.CharField(default=b'', max_length=3, blank=True),
        ),
        migrations.AlterField(
            model_name='profile',
            name='gender',
            field=models.CharField(default=b'', max_length=64, blank=True, choices=[(b'', b'---'), (b'male', b'Male'), (b'female', b'Female')]),
        ),
        migrations.AlterField(
            model_name='userrole',
            name='user',
            field=models.ForeignKey(to=settings.AUTH_USER_MODEL),
        ),
    ]
