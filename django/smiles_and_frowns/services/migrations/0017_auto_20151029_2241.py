# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0016_auto_20151028_2118'),
    ]

    operations = [
        migrations.CreateModel(
            name='PredefinedBoardBehavior',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(max_length=128)),
            ],
        ),
        migrations.CreateModel(
            name='PredefinedBoardBehaviorGroup',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(max_length=128)),
                ('behaviors', models.ManyToManyField(to='services.PredefinedBoardBehavior')),
            ],
        ),
        migrations.RemoveField(
            model_name='predefinedboard',
            name='board',
        ),
        migrations.AddField(
            model_name='predefinedboard',
            name='title',
            field=models.CharField(default='predefined board', max_length=128),
            preserve_default=False,
        ),
    ]
