# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0014_auto_20151028_2040'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userrole',
            name='role',
            field=models.CharField(default=b'child', max_length=64, null=True, choices=[(b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')]),
        ),
    ]
