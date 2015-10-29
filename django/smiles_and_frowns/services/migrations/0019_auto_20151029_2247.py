# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0018_predefinedboard_behaviors'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='predefinedboard',
            name='behaviors',
        ),
        migrations.RemoveField(
            model_name='predefinedboardbehaviorgroup',
            name='behaviors',
        ),
        migrations.DeleteModel(
            name='PredefinedBoard',
        ),
        migrations.DeleteModel(
            name='PredefinedBoardBehavior',
        ),
        migrations.DeleteModel(
            name='PredefinedBoardBehaviorGroup',
        ),
    ]
