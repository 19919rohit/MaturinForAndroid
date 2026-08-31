#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO="19919rohit/MaturinForAndroid"
API="https://api.github.com/repos/$REPO/releases/latest"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
BIN="$PREFIX/bin/maturin"
TMP="$PREFIX/tmp/maturin-install"

printf '\n==> MaturinForAndroid installer\n'

command -v curl >/dev/null 2>&1 || {
    echo "Error: curl is required."
    echo "Install it with: pkg install curl"
    exit 1
}

command -v python >/dev/null 2>&1 || {
    echo "Error: Python is required."
    exit 1
}

ARCH="$(uname -m)"
[ "$ARCH" = "aarch64" ] || {
    echo "Error: unsupported architecture: $ARCH"
    echo "This release supports ARM64 (aarch64) Android."
    exit 1
}

mkdir -p "$TMP"
rm -f "$TMP"/*

echo "==> Checking latest release..."

ASSET_URL="$(
    curl -fsSL "$API" |
    python -c '
import json,sys
data=json.load(sys.stdin)
assets=data.get("assets",[])
for a in assets:
    name=a.get("name","").lower()
    if "maturin" in name and ("android" in name or "aarch64" in name or "arm64" in name):
        print(a["browser_download_url"])
        break
'
)"

[ -n "$ASSET_URL" ] || {
    echo "Error: no compatible Maturin Android ARM64 release asset found."
    exit 1
}

ASSET_NAME="${ASSET_URL##*/}"
DOWNLOAD="$TMP/$ASSET_NAME"

echo "==> Downloading $ASSET_NAME"
curl -fL --retry 3 --progress-bar "$ASSET_URL" -o "$DOWNLOAD"

echo "==> Installing..."

case "$ASSET_NAME" in
    *.tar.gz|*.tgz)
        tar -xzf "$DOWNLOAD" -C "$TMP"
        FOUND="$(find "$TMP" -type f -name maturin -print -quit)"
        ;;
    *.zip)
        command -v unzip >/dev/null 2>&1 || {
            echo "Error: unzip is required."
            echo "Install it with: pkg install unzip"
            exit 1
        }
        unzip -qo "$DOWNLOAD" -d "$TMP"
        FOUND="$(find "$TMP" -type f -name maturin -print -quit)"
        ;;
    maturin|maturin-*)
        FOUND="$DOWNLOAD"
        ;;
    *)
        echo "Error: unsupported release asset: $ASSET_NAME"
        exit 1
        ;;
esac

[ -n "$FOUND" ] || {
    echo "Error: maturin binary was not found in the release."
    exit 1
}

install -m 755 "$FOUND" "$BIN"
rm -rf "$TMP"

echo
echo "==> Installation complete!"
echo "==> Location: $BIN"
echo "==> Version:"
"$BIN" --version
echo
