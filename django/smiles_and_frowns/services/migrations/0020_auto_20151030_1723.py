# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0019_auto_20151029_2247'),
    ]

    operations = [
        migrations.AddField(
            model_name='frown',
            name='note',
            field=models.CharField(default=b'', max_length=256, blank=True),
        ),
        migrations.AddField(
            model_name='smile',
            name='note',
            field=models.CharField(default=b'', max_length=256, blank=True),
        ),
    ]
