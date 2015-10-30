# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedboard',
            name='uuid',
            field=models.CharField(default='', max_length=64),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='predefinedboardbehavior',
            name='uuid',
            field=models.CharField(default='', max_length=64),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='predefinedboardbehaviorgroup',
            name='uuid',
            field=models.CharField(default='', max_length=64),
            preserve_default=False,
        ),
    ]
