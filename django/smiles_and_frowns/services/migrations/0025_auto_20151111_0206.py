# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0024_auto_20151105_1525'),
    ]

    operations = [
        migrations.AddField(
            model_name='invite',
            name='invitee_firstname',
            field=models.CharField(max_length=1238, null=True),
        ),
        migrations.AddField(
            model_name='invite',
            name='invitee_lastname',
            field=models.CharField(max_length=1238, null=True),
        ),
    ]
