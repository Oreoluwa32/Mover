#!/bin/bash
# Load environment variables from .env file
source .env

# Run Flutter with environment variables
flutter run --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY --dart-define=GOOGLE_PLACES_API_KEY=$GOOGLE_PLACES_API_KEY
