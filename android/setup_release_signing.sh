#!/usr/bin/env bash
set -euo pipefail

ANDROID_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY_PROPS="$ANDROID_DIR/key.properties"
KEYSTORE_DIR="$ANDROID_DIR/keystore"
KEYSTORE_FILE="$KEYSTORE_DIR/upload-keystore.jks"
KEY_ALIAS="${KEY_ALIAS:-upload}"

if [[ -f "$KEY_PROPS" ]]; then
  echo "android/key.properties already exists. Remove it first to re-run setup."
  exit 1
fi

mkdir -p "$KEYSTORE_DIR"

if [[ ! -f "$KEYSTORE_FILE" ]]; then
  echo "Creating release keystore at android/keystore/upload-keystore.jks"
  echo "You will be prompted for store and key passwords (use a password manager)."
  keytool -genkeypair -v \
    -storetype PKCS12 \
    -keystore "$KEYSTORE_FILE" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000
else
  echo "Using existing keystore: $KEYSTORE_FILE"
fi

read -r -s -p "Store password: " STORE_PASSWORD
echo
read -r -s -p "Key password [same as store]: " KEY_PASSWORD
echo
KEY_PASSWORD="${KEY_PASSWORD:-$STORE_PASSWORD}"

cat > "$KEY_PROPS" <<EOF
storePassword=${STORE_PASSWORD}
keyPassword=${KEY_PASSWORD}
keyAlias=${KEY_ALIAS}
storeFile=keystore/upload-keystore.jks
EOF

chmod 600 "$KEY_PROPS"
echo "Created android/key.properties (mode 600)."
echo "Build with: flutter build appbundle --release"
