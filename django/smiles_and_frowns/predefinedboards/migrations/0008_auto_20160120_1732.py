# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0007_predefinedboard_group'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='predefinedboard',
            name='group',
        ),
        migrations.AddField(
            model_name='predefinedbehavior',
            name='group',
            field=models.CharField(default=b'', max_length=128, null=True, blank=True),
        ),
        migrations.AddField(
            model_name='predefinedbehavior',
            name='soft_delete',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='predefinedbehaviorgroup',
            name='soft_delete',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='predefinedboard',
            name='soft_delete',
            field=models.BooleanField(default=False),
        ),
    ]
