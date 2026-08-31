#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO="19919rohit/MaturinForAndroid"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
BIN="$PREFIX/bin/maturin"
TMP="$PREFIX/tmp/maturin-install"

command -v curl >/dev/null || {
    echo "Error: curl is required. Install it with: pkg install curl"
    exit 1
}

command -v python >/dev/null || {
    echo "Error: Python is required."
    exit 1
}

[ "$(uname -m)" = "aarch64" ] || {
    echo "Error: this installer requires an ARM64 (aarch64) device."
    exit 1
}

mkdir -p "$TMP"
rm -rf "$TMP"/*

echo "Available Maturin releases:"
echo

curl -fsSL "https://api.github.com/repos/$REPO/releases" |
python -c '
import json,sys
for r in json.load(sys.stdin):
    if not r.get("draft"):
        print("  " + r["tag_name"])
'

echo
printf "Enter release tag (for example, v1.14.1-android): "
read -r TAG

[ -n "$TAG" ] || {
    echo "Error: release tag is required."
    exit 1
}

echo
echo "==> Finding Android ARM64 binary..."

URL="$(
curl -fsSL "https://api.github.com/repos/$REPO/releases/tags/$TAG" |
python -c '
import json,sys
d=json.load(sys.stdin)
for a in d.get("assets",[]):
    n=a["name"].lower()
    if "android" in n and ("aarch64" in n or "arm64" in n):
        print(a["browser_download_url"])
        break
'
)"

[ -n "$URL" ] || {
    echo "Error: no Android ARM64 binary found for $TAG."
    exit 1
}

NAME="${URL##*/}"
FILE="$TMP/$NAME"

echo "==> Downloading $NAME"
curl -fL --retry 3 --progress-bar "$URL" -o "$FILE"

echo "==> Installing..."

case "$NAME" in
    *.tar.gz|*.tgz)
        tar -xzf "$FILE" -C "$TMP"
        FOUND="$(find "$TMP" -type f -name maturin -print -quit)"
        ;;
    *.zip)
        command -v unzip >/dev/null || {
            echo "Error: unzip is required. Install it with: pkg install unzip"
            exit 1
        }
        unzip -qo "$FILE" -d "$TMP"
        FOUND="$(find "$TMP" -type f -name maturin -print -quit)"
        ;;
    *)
        FOUND="$FILE"
        ;;
esac

[ -f "$FOUND" ] || {
    echo "Error: Maturin binary not found."
    exit 1
}

install -m 755 "$FOUND" "$BIN"
rm -rf "$TMP"

echo
echo "Maturin installed successfully."
echo "Location: $BIN"
echo "Version:"
"$BIN" --version
