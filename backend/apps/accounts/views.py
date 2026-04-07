from __future__ import annotations

from rest_framework import permissions, response, status, viewsets
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenRefreshView

from .models import KycRecord, UserProfile, Vehicle
from .serializers import (
    AccountOverviewSerializer,
    KycRecordSerializer,
    LoginSerializer,
    RegisterSerializer,
    UserProfileSerializer,
    UserSerializer,
    VehicleSerializer,
)


class RegisterView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        UserProfile.objects.get_or_create(user=user)
        login_data = LoginSerializer(
            data={"email": user.email, "password": request.data.get("password")}
        )
        login_data.is_valid(raise_exception=True)
        return response.Response(
            {
                "user": UserSerializer(user).data,
                "tokens": login_data.validated_data["tokens"],
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return response.Response(
            {
                "user": UserSerializer(serializer.validated_data["user"]).data,
                "tokens": serializer.validated_data["tokens"],
            }
        )


class MeView(APIView):
    def get(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        payload = {
            "user": request.user,
            "profile": profile,
            "vehicles": request.user.vehicles.all(),
            "kyc": getattr(request.user, "kyc_record", None),
        }
        return response.Response(AccountOverviewSerializer(payload).data)


class ProfileView(APIView):
    def get(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        return response.Response(UserProfileSerializer(profile).data)

    def put(self, request):
        profile, _ = UserProfile.objects.get_or_create(user=request.user)
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return response.Response(serializer.data)


class VehicleViewSet(viewsets.ModelViewSet):
    serializer_class = VehicleSerializer

    def get_queryset(self):
        return Vehicle.objects.filter(owner=self.request.user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class KycRecordView(APIView):
    def get(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        return response.Response(KycRecordSerializer(kyc).data)

    def put(self, request):
        kyc, _ = KycRecord.objects.get_or_create(user=request.user)
        serializer = KycRecordSerializer(kyc, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return response.Response(serializer.data)


class LiveStatusView(APIView):
    def get(self, request):
        active_plan = request.user.travel_plans.filter(is_live=True).order_by("-updated_at").first()
        return response.Response(
            {
                "status": True,
                "is_live": bool(active_plan),
                "travel_plan_id": str(active_plan.id) if active_plan else None,
            }
        )


class MovrTokenRefreshView(TokenRefreshView):
    permission_classes = [permissions.AllowAny]
