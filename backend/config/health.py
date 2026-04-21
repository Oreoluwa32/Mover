from django.http import JsonResponse


class HealthCheckMiddleware:
    """Return health checks before host validation runs.

    Koyeb probes the service through changing internal IP host headers, which
    Django rejects before URL routing. This keeps the bypass scoped to health.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path_info in {"/health", "/health/"}:
            return JsonResponse({"status": "ok", "service": "movr-backend"})

        return self.get_response(request)
