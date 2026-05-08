# Movr

Movr is a mobility and logistics platform with a Flutter mobile client and a Django backend. It supports ride sharing, delivery flows, route publishing, live location, wallet funding, email verification, password reset, and admin operations.

This repository contains:

- `lib/`: Flutter mobile application
- `backend/`: Django + Django REST Framework + Channels backend
- `assets/`: images, fonts, animation assets, and UI resources
- `docs/`: project documentation

## Documentation

Start here:

- [Documentation Index](C:/Users/oreol/Documents/Projects/Movr/docs/README.md)
- [Getting Started](C:/Users/oreol/Documents/Projects/Movr/docs/getting-started.md)
- [Architecture](C:/Users/oreol/Documents/Projects/Movr/docs/architecture.md)
- [Backend Guide](C:/Users/oreol/Documents/Projects/Movr/docs/backend.md)
- [Mobile App Guide](C:/Users/oreol/Documents/Projects/Movr/docs/mobile.md)
- [API Overview](C:/Users/oreol/Documents/Projects/Movr/docs/api.md)
- [Deployment Guide](C:/Users/oreol/Documents/Projects/Movr/docs/deployment.md)
- [Operations Guide](C:/Users/oreol/Documents/Projects/Movr/docs/operations.md)

## Quick Start

### Mobile app

```bash
flutter pub get
flutter run --dart-define=MOVR_API_BASE_URL=http://10.0.2.2:8000 --dart-define=MOVR_WS_BASE_URL=ws://10.0.2.2:8000 --dart-define=MOVR_ENVIRONMENT=development --dart-define=GOOGLE_MAPS_API_KEY=your_key --dart-define=GOOGLE_PLACES_API_KEY=your_key
```

### Backend

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

For the full project setup, environment variables, and deployment notes, use the docs folder.
