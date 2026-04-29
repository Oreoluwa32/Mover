from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("accounts", "0002_emailverificationcode"),
    ]

    operations = [
        migrations.RunSQL(
            sql=(
                "UPDATE accounts_emailverificationcode "
                "SET code = RIGHT(code, 4) "
                "WHERE LENGTH(code) > 4;"
            ),
            reverse_sql=migrations.RunSQL.noop,
        ),
        migrations.AlterField(
            model_name="emailverificationcode",
            name="code",
            field=models.CharField(max_length=4),
        ),
    ]
