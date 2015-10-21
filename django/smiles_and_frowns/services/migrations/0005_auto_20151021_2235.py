# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('services', '0004_auto_20151021_2201'),
    ]

    operations = [
        migrations.CreateModel(
            name='UserRole',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('role', models.CharField(default=b'child', max_length=64, choices=[(b'owner', b'Owner'), (b'parent', b'Parent'), (b'guardian', b'Guardian'), (b'child', b'Child')])),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.RemoveField(
            model_name='profile',
            name='role',
        ),
        migrations.AlterField(
            model_name='board',
            name='users',
            field=models.ManyToManyField(to='services.UserRole', blank=True),
        ),
    ]
