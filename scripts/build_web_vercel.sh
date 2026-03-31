#!/usr/bin/env bash
set -euo pipefail

# Use web-specific assets (without .env) for Vercel web build.
cp pubspec.web.yaml pubspec.yaml
flutter pub get

flutter build web --release \
  --dart-define=API_BASE_URL="${API_BASE_URL:-}" \
  --dart-define=API_BASE_URL_WEB="${API_BASE_URL_WEB:-}" \
  --dart-define=FIREBASE_API_KEY="${FIREBASE_API_KEY:-}" \
  --dart-define=FIREBASE_AUTH_DOMAIN="${FIREBASE_AUTH_DOMAIN:-}" \
  --dart-define=FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-}" \
  --dart-define=FIREBASE_STORAGE_BUCKET="${FIREBASE_STORAGE_BUCKET:-}" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="${FIREBASE_MESSAGING_SENDER_ID:-}" \
  --dart-define=FIREBASE_APP_ID="${FIREBASE_APP_ID:-}" \
  --dart-define=GOOGLE_WEB_CLIENT_ID="${GOOGLE_WEB_CLIENT_ID:-}"
