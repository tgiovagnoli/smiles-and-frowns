# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0033_auto_20160107_2029'),
    ]

    operations = [
        migrations.AlterField(
            model_name='behavior',
            name='predefined_behavior_uuid',
            field=models.CharField(default=b'', max_length=64, null=True),
        ),
        migrations.AlterField(
            model_name='board',
            name='predefined_board_uuid',
            field=models.CharField(default=b'', max_length=64, null=True),
        ),
    ]
