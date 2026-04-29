from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("accounts", "0002_emailverificationcode"),
    ]

    operations = [
        migrations.AlterField(
            model_name="emailverificationcode",
            name="code",
            field=models.CharField(max_length=4),
        ),
    ]
