# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0030_tempprofileimage'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tempprofileimage',
            name='image_height',
        ),
        migrations.RemoveField(
            model_name='tempprofileimage',
            name='image_width',
        ),
        migrations.AlterField(
            model_name='tempprofileimage',
            name='image',
            field=models.ImageField(default=None, null=True, upload_to=b'ProfileImage', blank=True),
        ),
    ]
