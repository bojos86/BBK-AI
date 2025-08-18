#!/usr/bin/env bash
# Usage:
#   ./setup_flutter.sh debug         # Build debug APK
#   ./setup_flutter.sh release       # Build release APK
#   ./setup_flutter.sh release --skip-sdk   # استخدم Flutter الموجود وما ينزله

set -euo pipefail

BUILD_TYPE="${1:-debug}"            # debug | release
SKIP_SDK="${2:-}"

PROJECT_DIR="/workspaces/bbk_ai_app"
FLUTTER_DIR="$HOME/flutter"
APK_PATH_DEBUG="$PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
APK_PATH_RELEASE="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"

echo ">>> Build type: $BUILD_TYPE"
echo ">>> Project: $PROJECT_DIR"

if [[ "$SKIP_SDK" != "--skip-sdk" ]]; then
  echo ">>> Updating system packages..."
  sudo apt-get update -y
  sudo apt-get install -y unzip xz-utils curl git

  if [[ ! -d "$FLUTTER_DIR" ]]; then
    echo ">>> Downloading Flutter SDK..."
    cd ~
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.0-stable.tar.xz \
      | tar -xJ
  else
    echo ">>> Flutter already exists at $FLUTTER_DIR"
  fi

  if ! grep -q 'flutter/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
  fi
  # load PATH in the current shell
  export PATH="$HOME/flutter/bin:$PATH"
fi

echo ">>> Flutter version:"
flutter --version

echo ">>> Go to project directory..."
cd "$PROJECT_DIR"

echo ">>> Flutter clean & pub get"
flutter clean
flutter pub get

# إعادة إنشاء أندرويد (لو تبي سكربت يفرض إعادة الإنشاء فعّله)
if [[ ! -d "android" ]]; then
  echo ">>> (android missing) Creating android folder..."
  flutter create . --platforms=android -i kotlin
fi

# توليد السبلـاش/الأيقونات إذا موجودة
if grep -q "flutter_native_splash" pubspec.yaml; then
  echo ">>> Generate native splash"
  dart run flutter_native_splash:create || true
fi
if grep -q "flutter_launcher_icons" pubspec.yaml; then
  echo ">>> Generate launcher icons"
  dart run flutter_launcher_icons:main || true
fi

# Build
if [[ "$BUILD_TYPE" == "release" ]]; then
  echo ">>> Building RELEASE APK..."
  flutter build apk --release -v | tee flutter_build.log
  echo ">>> APK:"
  ls -lah "$APK_PATH_RELEASE" || true
  echo ">>> Done. Path: $APK_PATH_RELEASE"
else
  echo ">>> Building DEBUG APK..."
  flutter build apk --debug -v | tee flutter_build.log
  echo ">>> APK:"
  ls -lah "$APK_PATH_DEBUG" || true
  echo ">>> Done. Path: $APK_PATH_DEBUG"
fi
