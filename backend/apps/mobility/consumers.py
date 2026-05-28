from __future__ import annotations

from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer
from django.db.models import Q
from django.utils import timezone

from config.jwt_auth import JWT_SUBPROTOCOL

from .models import TrackingEvent, TrackingSession, TravelPlan


class TrackingConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        self.travel_plan_id = self.scope["url_route"]["kwargs"]["travel_plan_id"]
        self.room_group_name = f"tracking_{self.travel_plan_id}"
        user = self.scope.get("user")

        if not user or not user.is_authenticated:
            await self.close(code=4401)
            return

        if not await self._user_can_access_plan(user, self.travel_plan_id):
            await self.close(code=4403)
            return

        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        subprotocol = (
            JWT_SUBPROTOCOL
            if JWT_SUBPROTOCOL in (self.scope.get("subprotocols") or [])
            else None
        )
        await self.accept(subprotocol=subprotocol)

    @database_sync_to_async
    def _user_can_access_plan(self, user, travel_plan_id) -> bool:
        return TravelPlan.objects.filter(
            Q(id=travel_plan_id)
            & (
                Q(created_by=user)
                | Q(matches__ride_request__requester=user)
                | Q(matches__delivery_request__requester=user)
            )
        ).exists()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive_json(self, content, **kwargs):
        event = await self._persist_event(content)
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                "type": "tracking.message",
                "event": event,
            },
        )

    async def tracking_message(self, event):
        await self.send_json(event["event"])

    @database_sync_to_async
    def _persist_event(self, content):
        user = self.scope["user"]
        travel_plan = TravelPlan.objects.get(id=self.travel_plan_id)
        session, _ = TrackingSession.objects.get_or_create(travel_plan=travel_plan)
        if session.status == TrackingSession.Status.IDLE:
            session.status = TrackingSession.Status.LIVE
            session.started_at = timezone.now()
            session.save(update_fields=["status", "started_at", "updated_at"])

        tracking_event = TrackingEvent.objects.create(
            session=session,
            actor=user,
            event_type=content.get("event_type", TrackingEvent.EventType.LOCATION),
            latitude=content.get("latitude"),
            longitude=content.get("longitude"),
            note=content.get("note", ""),
            payload=content.get("payload", {}),
        )
        return {
            "id": str(tracking_event.id),
            "event_type": tracking_event.event_type,
            "latitude": (
                float(tracking_event.latitude)
                if tracking_event.latitude is not None
                else None
            ),
            "longitude": (
                float(tracking_event.longitude)
                if tracking_event.longitude is not None
                else None
            ),
            "note": tracking_event.note,
            "payload": tracking_event.payload,
            "created_at": tracking_event.created_at.isoformat(),
            "actor": user.email,
        }
