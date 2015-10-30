# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0022_invite_sender'),
    ]

    operations = [
        migrations.AddField(
            model_name='invite',
            name='uuid',
            field=models.CharField(max_length=64, unique=True, null=True),
        ),
    ]
