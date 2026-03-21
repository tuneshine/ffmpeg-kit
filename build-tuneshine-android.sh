#!/bin/bash
# Tuneshine Android build script
#
# Builds a minimal ffmpeg-kit AAR for the tuneshine app with 16KB page size
# support (required by Google Play for Android 15+ devices).
#
# Libraries included:
#   libwebp  - WebP encoding (static + animated, all ffmpeg output formats)
#   x264     - H.264 encoding (intermediate video truncation step, GPL)
#
# Architectures: arm64-v8a, x86_64 (64-bit only; 16KB page size is 64-bit only)
#
# Output: bundle-android-aar/ffmpeg-kit/ffmpeg-kit.aar

set -e

ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-/Users/tobiasbutler/Library/Android/sdk}"
ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-$ANDROID_SDK_ROOT/ndk/27.2.12479018}"

if [[ ! -d "$ANDROID_SDK_ROOT" ]]; then
  echo "ERROR: ANDROID_SDK_ROOT not found at $ANDROID_SDK_ROOT"
  exit 1
fi

if [[ ! -d "$ANDROID_NDK_ROOT" ]]; then
  echo "ERROR: ANDROID_NDK_ROOT not found at $ANDROID_NDK_ROOT"
  echo "Install NDK 27.1.12297006 (r27b) via Android Studio or sdkmanager."
  exit 1
fi

export ANDROID_SDK_ROOT
export ANDROID_NDK_ROOT

echo "Using SDK: $ANDROID_SDK_ROOT"
echo "Using NDK: $ANDROID_NDK_ROOT"
echo ""

./android.sh \
  --enable-gpl \
  --enable-libwebp \
  --enable-x264 \
  --disable-arm-v7a \
  --disable-arm-v7a-neon \
  --disable-x86
