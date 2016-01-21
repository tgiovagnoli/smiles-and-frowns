# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0008_auto_20160120_1732'),
    ]

    operations = [
        migrations.AlterField(
            model_name='predefinedboard',
            name='behaviors',
            field=models.ManyToManyField(to='predefinedboards.PredefinedBehavior', null=True, blank=True),
        ),
    ]
