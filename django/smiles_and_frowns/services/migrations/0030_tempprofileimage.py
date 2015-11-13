# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0029_auto_20151112_2351'),
    ]

    operations = [
        migrations.CreateModel(
            name='TempProfileImage',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uuid', models.CharField(max_length=64, unique=True, null=True)),
                ('created_date', models.DateTimeField(auto_now_add=True, null=True)),
                ('updated_date', models.DateTimeField(auto_now=True, null=True)),
                ('image_width', models.PositiveIntegerField(default=100, null=True, editable=False, blank=True)),
                ('image_height', models.PositiveIntegerField(default=100, null=True, editable=False, blank=True)),
                ('image', models.ImageField(default=None, height_field=b'image_height', width_field=b'image_width', upload_to=b'TempProfileImage', blank=True, null=True)),
            ],
        ),
    ]
