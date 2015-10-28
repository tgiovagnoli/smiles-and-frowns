# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0011_auto_20151023_2158'),
    ]

    operations = [
        migrations.AlterField(
            model_name='behavior',
            name='note',
            field=models.CharField(default=b'', max_length=256, null=True, blank=True),
        ),
        migrations.AlterField(
            model_name='frown',
            name='behavior',
            field=models.ForeignKey(to='services.Behavior', null=True),
        ),
        migrations.AlterField(
            model_name='frown',
            name='user',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='invite',
            name='role',
            field=models.CharField(default=b'guardian', max_length=64, choices=[(b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')]),
        ),
        migrations.AlterField(
            model_name='smile',
            name='behavior',
            field=models.ForeignKey(to='services.Behavior', null=True),
        ),
        migrations.AlterField(
            model_name='userrole',
            name='role',
            field=models.CharField(default=b'child', max_length=64, choices=[(b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')]),
        ),
    ]
