# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0017_auto_20151029_2241'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedboard',
            name='behaviors',
            field=models.ManyToManyField(to='services.PredefinedBoardBehavior'),
        ),
    ]
