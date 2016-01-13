# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0005_predefinedboard_list_sort'),
    ]

    operations = [
        migrations.AddField(
            model_name='predefinedboard',
            name='description',
            field=models.CharField(default=b'', max_length=2048, null=True, blank=True),
        ),
    ]
