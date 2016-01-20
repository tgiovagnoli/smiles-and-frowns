# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0006_predefinedboard_description'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedboard',
            name='group',
            field=models.CharField(default=b'', max_length=128, null=True, blank=True),
        ),
    ]
