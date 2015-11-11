# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0026_auto_20151111_0218'),
    ]

    operations = [
        migrations.AddField(
            model_name='behavior',
            name='positive',
            field=models.BooleanField(default=True),
        ),
    ]
