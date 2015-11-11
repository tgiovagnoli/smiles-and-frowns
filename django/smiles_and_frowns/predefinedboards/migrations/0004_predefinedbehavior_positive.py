# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0003_auto_20151102_1909'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedbehavior',
            name='positive',
            field=models.BooleanField(default=True),
        ),
    ]
