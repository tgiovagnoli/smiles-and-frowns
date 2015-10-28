# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0012_auto_20151028_0016'),
    ]

    operations = [
        migrations.AlterField(
            model_name='reward',
            name='title',
            field=models.CharField(max_length=128, null=True),
        ),
    ]
