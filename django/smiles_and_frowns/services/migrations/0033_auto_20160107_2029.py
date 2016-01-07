# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0032_auto_20160107_2000'),
    ]

    operations = [
        migrations.AlterField(
            model_name='behavior',
            name='predefined_behavior_uuid',
            field=models.CharField(default=b'', max_length=64),
        ),
        migrations.AlterField(
            model_name='board',
            name='predefined_board_uuid',
            field=models.CharField(default=b'', max_length=64),
        ),
    ]
