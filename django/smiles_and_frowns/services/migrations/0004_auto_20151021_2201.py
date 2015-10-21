# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0003_auto_20151021_2141'),
    ]

    operations = [
        migrations.RenameField(
            model_name='invite',
            old_name='user_owner',
            new_name='user',
        ),
        migrations.AlterField(
            model_name='board',
            name='edit_count',
            field=models.IntegerField(default=0),
        ),
    ]
