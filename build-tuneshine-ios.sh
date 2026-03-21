#!/bin/bash
# Tuneshine iOS build script
#
# Builds a minimal ffmpeg-kit xcframework bundle for the tuneshine app.
#
# Libraries included:
#   libwebp  - WebP encoding (static + animated, all ffmpeg output formats)
#   x264     - H.264 encoding (intermediate video truncation step, GPL)
#
# Architectures:
#   arm64            - physical iPhones/iPads
#   arm64-simulator  - Apple Silicon simulators
#   x86_64           - Intel Mac simulators
#
# Output: prebuilt/bundle-apple-xcframework-ios/*.xcframework
#         prebuilt/ffmpeg-kit-ios-full-gpl-latest.zip  (ready to host + use as iosUrl)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure autoconf cross-compilation detection works on Apple Silicon.
# Without this, arm64 host ≈ arm64 build causes configure to hang.
export BUILD="$(uname -m)-apple-darwin"

# The zip path structure must match vendored_frameworks in the config plugin podspec
ZIP_INNER_DIR="ffmpeg-kit-ios-full-gpl-latest/ffmpeg-kit-ios-full-gpl/6.0-80adc"
ZIP_NAME="ffmpeg-kit-ios-full-gpl-latest.zip"
XCFRAMEWORK_DIR="prebuilt/bundle-apple-xcframework-ios"
OUTPUT_ZIP="prebuilt/${ZIP_NAME}"

./ios.sh \
  --xcframework \
  --enable-gpl \
  --enable-libwebp \
  --enable-x264 \
  --disable-armv7 \
  --disable-armv7s \
  --disable-arm64e \
  --disable-i386 \
  --disable-arm64-mac-catalyst \
  --disable-x86-64-mac-catalyst

echo ""
echo -n "Packaging xcframeworks into ${OUTPUT_ZIP}: "

rm -rf /tmp/ffmpeg-kit-ios-pkg
mkdir -p "/tmp/ffmpeg-kit-ios-pkg/${ZIP_INNER_DIR}"

cp -R "${XCFRAMEWORK_DIR}/"*.xcframework "/tmp/ffmpeg-kit-ios-pkg/${ZIP_INNER_DIR}/"

rm -f "${OUTPUT_ZIP}"
cd /tmp/ffmpeg-kit-ios-pkg
zip -r --symlinks "${SCRIPT_DIR}/${OUTPUT_ZIP}" . 1>/dev/null
cd "$SCRIPT_DIR"

echo "ok"
echo ""
echo "Output: ${OUTPUT_ZIP} ($(du -sh "${OUTPUT_ZIP}" | cut -f1))"
echo ""
echo "Host this file and set it as 'iosUrl' in your app.config.ts plugin options."
