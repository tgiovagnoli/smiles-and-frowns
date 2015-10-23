# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0010_auto_20151023_2144'),
    ]

    operations = [
        migrations.AlterField(
            model_name='behavior',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='board',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL, null=True),
        ),
        migrations.AlterField(
            model_name='frown',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='invite',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='invite',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, blank=True, to=settings.AUTH_USER_MODEL, null=True),
        ),
        migrations.AlterField(
            model_name='predefinedboard',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='reward',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='smile',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='smile',
            name='user',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='userrole',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='services.Board', null=True),
        ),
        migrations.AlterField(
            model_name='userrole',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL, null=True),
        ),
    ]
