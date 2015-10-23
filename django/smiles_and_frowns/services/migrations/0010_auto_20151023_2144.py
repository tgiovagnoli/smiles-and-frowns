# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0009_auto_20151022_2027'),
    ]

    operations = [
        migrations.AddField(
            model_name='invite',
            name='role',
            field=models.CharField(default=b'guardian', max_length=64, choices=[(b'owner', b'Owner'), (b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')]),
        ),
        migrations.AlterField(
            model_name='reward',
            name='currency_amount',
            field=models.FloatField(default=1),
        ),
        migrations.AlterField(
            model_name='reward',
            name='smile_amount',
            field=models.FloatField(default=1),
        ),
    ]
