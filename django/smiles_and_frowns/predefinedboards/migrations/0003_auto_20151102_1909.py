# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('predefinedboards', '0002_auto_20151029_2301'),
    ]

    operations = [
        migrations.CreateModel(
            name='PredefinedBehaviorGroup',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(max_length=128)),
                ('uuid', models.CharField(max_length=64)),
            ],
        ),
        migrations.RenameModel(
            old_name='PredefinedBoardBehavior',
            new_name='PredefinedBehavior',
        ),
        migrations.RemoveField(
            model_name='predefinedboardbehaviorgroup',
            name='behaviors',
        ),
        migrations.DeleteModel(
            name='PredefinedBoardBehaviorGroup',
        ),
        migrations.AddField(
            model_name='predefinedbehaviorgroup',
            name='behaviors',
            field=models.ManyToManyField(to='predefinedboards.PredefinedBehavior'),
        ),
    ]
