from django.db import migrations, models


def truncate_codes_to_last_four(apps, schema_editor):
    EmailVerificationCode = apps.get_model("accounts", "EmailVerificationCode")
    for record in EmailVerificationCode.objects.all().iterator():
        if len(record.code) > 4:
            record.code = record.code[-4:]
            record.save(update_fields=["code"])


class Migration(migrations.Migration):

    dependencies = [
        ("accounts", "0002_emailverificationcode"),
    ]

    operations = [
        migrations.RunPython(
            truncate_codes_to_last_four,
            reverse_code=migrations.RunPython.noop,
        ),
        migrations.AlterField(
            model_name="emailverificationcode",
            name="code",
            field=models.CharField(max_length=4),
        ),
    ]
