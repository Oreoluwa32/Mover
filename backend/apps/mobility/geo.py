"""Spatial helpers for Movr mobility matching and live tracking.

Two capabilities live here:

* **H3 corridor cells** — every published TravelPlan gets an ordered list
  of H3 resolution-8 cells (~460 m diameter) between its origin and
  destination. Rider/parcel requests are matched by asking "does this
  request's pickup cell AND dropoff cell both fall inside a plan's
  corridor, with pickup before dropoff?" which is a cheap set-and-index
  check instead of the old substring `origin_name__icontains` fuzz.

* **Redis GEO for live movers** — active drivers report their position
  through the tracking WebSocket. We mirror every location tick into
  `GEOADD movers:live lng lat mover_id` so proximity queries answer in
  sub-millisecond time without touching Postgres, and stale entries can
  be swept lazily.

Both features degrade cleanly when the underlying library is missing so
tests and local dev keep passing without Redis or the h3 wheel.
"""

from __future__ import annotations

import logging
from typing import Iterable

logger = logging.getLogger(__name__)

# Resolution 8 hexagons: ~460 m across, ~0.7 km^2. Good compromise
# between corridor precision (matches a bus route) and index size (a
# 20 km trip needs ~40 cells).
CORRIDOR_H3_RESOLUTION = 8

# Redis key for the sorted-set that indexes live mover positions.
LIVE_MOVERS_GEO_KEY = "movers:live"

# Live positions older than this are considered stale and get culled.
LIVE_POSITION_TTL_SECONDS = 90

try:
    import h3  # type: ignore

    _H3_AVAILABLE = True
except Exception:  # pragma: no cover - optional dependency
    h3 = None  # type: ignore
    _H3_AVAILABLE = False


def h3_available() -> bool:
    return _H3_AVAILABLE


def cell_for_coord(
    lat: float | None,
    lng: float | None,
    resolution: int = CORRIDOR_H3_RESOLUTION,
) -> str | None:
    """Return the H3 cell id for a coordinate, or None if unusable."""
    if not _H3_AVAILABLE or lat is None or lng is None:
        return None
    try:
        return h3.latlng_to_cell(float(lat), float(lng), resolution)
    except Exception:
        return None


def corridor_cells(
    origin_lat: float | None,
    origin_lng: float | None,
    dest_lat: float | None,
    dest_lng: float | None,
    resolution: int = CORRIDOR_H3_RESOLUTION,
) -> list[str]:
    """Ordered H3 cells covering the great-circle path from origin to
    destination. Empty when H3 is unavailable or either endpoint is
    missing coordinates.
    """
    if not _H3_AVAILABLE:
        return []
    origin = cell_for_coord(origin_lat, origin_lng, resolution)
    dest = cell_for_coord(dest_lat, dest_lng, resolution)
    if not origin or not dest:
        return []
    if origin == dest:
        return [origin]
    try:
        return list(h3.grid_path_cells(origin, dest))
    except Exception:
        # `grid_path_cells` can raise when two cells are too far apart
        # for pentagon-safe pathing. Fall back to endpoint-only so the
        # match still has *some* corridor to intersect.
        return [origin, dest]


def request_hits_corridor(
    corridor: Iterable[str],
    pickup_cell: str | None,
    dropoff_cell: str | None,
) -> bool:
    """True when both pickup and dropoff cells lie in the corridor and
    the pickup comes before (or equals) the dropoff along the path.
    """
    if not pickup_cell or not dropoff_cell:
        return False
    corridor_list = list(corridor)
    if not corridor_list:
        return False
    try:
        pickup_idx = corridor_list.index(pickup_cell)
        dropoff_idx = corridor_list.index(dropoff_cell)
    except ValueError:
        return False
    return pickup_idx <= dropoff_idx


def _get_redis_client():
    """Return a redis client sourced from CHANNEL_LAYERS, or None."""
    try:
        from django.conf import settings

        cfg = (settings.CHANNEL_LAYERS or {}).get("default") or {}
        hosts = ((cfg.get("CONFIG") or {}).get("hosts")) or []
        if not hosts:
            return None
        host = hosts[0]
        import redis  # type: ignore

        if isinstance(host, str):
            return redis.Redis.from_url(host, decode_responses=True)
        # tuple form: (host, port)
        return redis.Redis(host=host[0], port=host[1], decode_responses=True)
    except Exception:
        return None


def record_live_position(mover_id: str, lat: float, lng: float) -> None:
    """Best-effort insert of a mover's position into the Redis GEO index.

    A failure here must never break the underlying tracking event write
    or the WebSocket loop, so all errors are swallowed after logging.
    """
    client = _get_redis_client()
    if client is None:
        return
    try:
        client.geoadd(LIVE_MOVERS_GEO_KEY, [float(lng), float(lat), str(mover_id)])
        # Track freshness so we can expire stale entries later.
        import time

        client.zadd(f"{LIVE_MOVERS_GEO_KEY}:seen", {str(mover_id): time.time()})
    except Exception:
        logger.debug("Redis geoadd failed", exc_info=True)


def search_nearby_movers(
    lat: float,
    lng: float,
    radius_km: float = 3.0,
    max_results: int = 50,
) -> list[dict]:
    """Return live movers within radius_km of (lat, lng), ordered by
    distance ascending. Empty list if Redis is unreachable.
    """
    client = _get_redis_client()
    if client is None:
        return []
    try:
        results = client.geosearch(
            LIVE_MOVERS_GEO_KEY,
            longitude=float(lng),
            latitude=float(lat),
            radius=float(radius_km),
            unit="km",
            sort="ASC",
            count=max_results,
            withcoord=True,
            withdist=True,
        )
    except Exception:
        logger.debug("Redis geosearch failed", exc_info=True)
        return []

    parsed: list[dict] = []
    for row in results or []:
        try:
            mover_id, distance_km, coord = row
            parsed.append(
                {
                    "mover_id": mover_id,
                    "distance_km": float(distance_km),
                    "longitude": float(coord[0]),
                    "latitude": float(coord[1]),
                }
            )
        except Exception:
            continue
    return parsed


def cull_stale_positions(now_timestamp: float | None = None) -> int:
    """Remove positions from the GEO index whose last-seen timestamp is
    older than LIVE_POSITION_TTL_SECONDS. Returns the number of movers
    swept.
    """
    client = _get_redis_client()
    if client is None:
        return 0
    try:
        import time

        cutoff = (now_timestamp or time.time()) - LIVE_POSITION_TTL_SECONDS
        stale_ids = client.zrangebyscore(
            f"{LIVE_MOVERS_GEO_KEY}:seen", min="-inf", max=cutoff
        )
        if not stale_ids:
            return 0
        client.zrem(LIVE_MOVERS_GEO_KEY, *stale_ids)
        client.zrem(f"{LIVE_MOVERS_GEO_KEY}:seen", *stale_ids)
        return len(stale_ids)
    except Exception:
        logger.debug("Redis cull failed", exc_info=True)
        return 0
