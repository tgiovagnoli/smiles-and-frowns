# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0002_auto_20151021_2100'),
    ]

    operations = [
        migrations.AlterField(
            model_name='behavior',
            name='note',
            field=models.CharField(default=None, max_length=256, blank=True),
        ),
        migrations.AlterField(
            model_name='behavior',
            name='uuid',
            field=models.CharField(unique=True, max_length=64),
        ),
        migrations.AlterField(
            model_name='board',
            name='uuid',
            field=models.CharField(unique=True, max_length=64),
        ),
        migrations.AlterField(
            model_name='frown',
            name='uuid',
            field=models.CharField(unique=True, max_length=64),
        ),
        migrations.AlterField(
            model_name='profile',
            name='age',
            field=models.CharField(default=None, max_length=3, blank=True),
        ),
        migrations.AlterField(
            model_name='reward',
            name='uuid',
            field=models.CharField(unique=True, max_length=64),
        ),
        migrations.AlterField(
            model_name='smile',
            name='uuid',
            field=models.CharField(unique=True, max_length=64),
        ),
    ]
