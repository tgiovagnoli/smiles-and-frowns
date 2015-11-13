# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0028_profile_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='image_height',
            field=models.PositiveIntegerField(default=100, null=True, editable=False, blank=True),
        ),
        migrations.AddField(
            model_name='profile',
            name='image_width',
            field=models.PositiveIntegerField(default=100, null=True, editable=False, blank=True),
        ),
        migrations.AlterField(
            model_name='profile',
            name='image',
            field=models.ImageField(default=None, height_field=b'image_height', width_field=b'image_width', upload_to=b'ProfileImage', blank=True, null=True),
        ),
    ]
