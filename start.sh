#!/bin/bash

# Create qr_codes directory if missing and adjust permissions
mkdir -p /app/qr_codes
chmod 777 /app/qr_codes

# Toggle between dev and prod
if [ "$APP_ENV" = "production" ]; then
  echo "Starting in production mode..."
  gunicorn -k uvicorn.workers.UvicornWorker -w 4 -b :8000 app.main:app
else
  echo "Starting in development mode..."
  uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
fi

