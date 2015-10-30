# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0020_auto_20151030_1723'),
    ]

    operations = [
        migrations.AddField(
            model_name='invite',
            name='created_date',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AddField(
            model_name='invite',
            name='updated_date',
            field=models.DateTimeField(auto_now=True, null=True),
        ),
    ]
