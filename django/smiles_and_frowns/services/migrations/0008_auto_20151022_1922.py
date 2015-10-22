# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('services', '0007_auto_20151022_0047'),
    ]

    operations = [
        migrations.RenameField(
            model_name='board',
            old_name='in_app_purchase_id',
            new_name='transaction_id',
        ),
    ]
