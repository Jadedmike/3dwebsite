#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="${HOME}/flutter"

if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -d "${FLUTTER_DIR}" ]; then
    echo "Installing latest stable Flutter SDK..."
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
  fi
  export PATH="${FLUTTER_DIR}/bin:${PATH}"
fi

flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release
