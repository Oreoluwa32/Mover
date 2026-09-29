from django.db import migrations, models


def backfill_corridor_cells(apps, schema_editor):
    TravelPlan = apps.get_model("mobility", "TravelPlan")
    try:
        from apps.mobility.geo import corridor_cells
    except Exception:
        return

    for plan in TravelPlan.objects.all().iterator():
        cells = corridor_cells(
            origin_lat=(
                float(plan.origin_latitude)
                if plan.origin_latitude is not None
                else None
            ),
            origin_lng=(
                float(plan.origin_longitude)
                if plan.origin_longitude is not None
                else None
            ),
            dest_lat=(
                float(plan.destination_latitude)
                if plan.destination_latitude is not None
                else None
            ),
            dest_lng=(
                float(plan.destination_longitude)
                if plan.destination_longitude is not None
                else None
            ),
        )
        if cells:
            plan.corridor_h3_cells = cells
            plan.save(update_fields=["corridor_h3_cells"])


class Migration(migrations.Migration):
    dependencies = [
        ("mobility", "0004_alter_deliveryrequest_status_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="travelplan",
            name="corridor_h3_cells",
            field=models.JSONField(blank=True, default=list),
        ),
        migrations.RunPython(
            backfill_corridor_cells,
            reverse_code=migrations.RunPython.noop,
        ),
    ]
