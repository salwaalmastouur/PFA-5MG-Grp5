# Generated by Django 4.2.4 on 2023-09-13 21:54

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('demande', '0005_alter_demande_reponse_title'),
    ]

    operations = [
        migrations.RenameField(
            model_name='demande',
            old_name='reponse_title',
            new_name='repons_title',
        ),
    ]