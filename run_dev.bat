@echo off
setlocal enabledelayedexpansion

REM Read .env file and set variables
for /f "delims=" %%A in ('type .env') do (
  if not "%%A"=="" if not "%%A:~0,1%"=="#" (
    set "%%A"
  )
)

REM Display loaded keys (for debugging)
echo Loaded GOOGLE_MAPS_API_KEY: !GOOGLE_MAPS_API_KEY!
echo Loaded GOOGLE_PLACES_API_KEY: !GOOGLE_PLACES_API_KEY!

REM Run Flutter with the loaded environment variables
flutter run --dart-define=GOOGLE_MAPS_API_KEY=!GOOGLE_MAPS_API_KEY! --dart-define=GOOGLE_PLACES_API_KEY=!GOOGLE_PLACES_API_KEY!

endlocal
