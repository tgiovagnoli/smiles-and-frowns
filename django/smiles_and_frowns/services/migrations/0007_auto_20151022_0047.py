# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0006_auto_20151021_2240'),
    ]

    operations = [
        migrations.AddField(
            model_name='userrole',
            name='created_date',
            field=models.DateTimeField(default=datetime.datetime(2015, 10, 22, 0, 46, 58, 764791, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='userrole',
            name='deleted',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userrole',
            name='device_date',
            field=models.DateTimeField(default=datetime.datetime(2015, 10, 22, 0, 47, 3, 665291, tzinfo=utc)),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='userrole',
            name='updated_date',
            field=models.DateTimeField(default=datetime.datetime(2015, 10, 22, 0, 47, 8, 590109, tzinfo=utc), auto_now=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='userrole',
            name='uuid',
            field=models.CharField(default='85443488-7856-11e5-8bcf-feff819cdc9f', unique=True, max_length=64),
            preserve_default=False,
        ),
    ]
