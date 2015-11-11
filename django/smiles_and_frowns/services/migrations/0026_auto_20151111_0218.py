# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0025_auto_20151111_0206'),
    ]

    operations = [
        migrations.AddField(
            model_name='invite',
            name='invitee_email',
            field=models.CharField(max_length=256, null=True),
        ),
        migrations.AlterField(
            model_name='invite',
            name='invitee_firstname',
            field=models.CharField(max_length=128, null=True),
        ),
        migrations.AlterField(
            model_name='invite',
            name='invitee_lastname',
            field=models.CharField(max_length=128, null=True),
        ),
    ]
