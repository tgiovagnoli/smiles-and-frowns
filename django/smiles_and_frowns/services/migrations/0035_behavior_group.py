# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0034_auto_20160107_2051'),
    ]

    operations = [
        migrations.AddField(
            model_name='behavior',
            name='group',
            field=models.CharField(default=b'', max_length=128, null=True, blank=True),
        ),
    ]
