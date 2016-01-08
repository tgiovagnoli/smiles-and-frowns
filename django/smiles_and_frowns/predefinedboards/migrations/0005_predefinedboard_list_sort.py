# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0004_predefinedbehavior_positive'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedboard',
            name='list_sort',
            field=models.PositiveSmallIntegerField(default=0),
        ),
    ]
