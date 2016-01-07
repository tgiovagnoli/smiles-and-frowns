# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0031_auto_20151113_1847'),
    ]

    operations = [
        migrations.AddField(
            model_name='behavior',
            name='predefined_behavior_uuid',
            field=models.CharField(default=None, max_length=64, null=True, blank=True),
        ),
        migrations.AddField(
            model_name='board',
            name='predefined_board_uuid',
            field=models.CharField(default=None, max_length=64, null=True, blank=True),
        ),
    ]
