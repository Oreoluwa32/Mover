from django.urls import path

from . import views

app_name = "dashboard"

urlpatterns = [
    path("", views.dashboard, name="index"),
    path("users/", views.users, name="users"),
    path("kyc/", views.kyc_list, name="kyc"),
    path("kyc/<int:pk>/action/", views.kyc_action, name="kyc_action"),
    path("rides/", views.rides, name="rides"),
    path("delivery/", views.delivery, name="delivery"),
    path("live-tracking/", views.live_tracking, name="live_tracking"),
    path("api/live-tracking/", views.api_live_tracking, name="api_live_tracking"),
    path("analytics/", views.stub, {"screen": "analytics"}, name="analytics"),
    path("transactions/", views.stub, {"screen": "transactions"}, name="transactions"),
    path("chat-support/", views.stub, {"screen": "chat-support"}, name="chat_support"),
]
