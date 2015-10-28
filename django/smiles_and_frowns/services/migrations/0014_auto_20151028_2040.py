# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0013_auto_20151028_0018'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='board',
            name='edit_count',
        ),
        migrations.AlterField(
            model_name='board',
            name='transaction_id',
            field=models.CharField(default=b'', max_length=128, null=True, blank=True),
        ),
    ]
