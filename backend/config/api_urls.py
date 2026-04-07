from django.urls import include, path

urlpatterns = [
    path("auth/", include("apps.accounts.urls")),
    path("accounts/", include("apps.accounts.urls")),
    path("mobility/", include("apps.mobility.urls")),
    path("payments/", include("apps.payments.urls")),
]
