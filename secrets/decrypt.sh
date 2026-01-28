#!/usr/bin/env bash
set -euo pipefail

in="${1:-}"
outdir="${2:-out}"

if [[ -z "$in" || ! -f "$in" ]]; then
  echo "Usage: $0 <file.zip.aes> [outdir]" >&2
  exit 1
fi

mkdir -p "$outdir"
tmpzip="$(mktemp -t secrets.XXXXXX).zip"

# Passwort einlesen (ohne Echo)
read -s -p "Passwort: " pw
echo

derive_key_iv() {
  local enc="$1"
  python3 -W "ignore::DeprecationWarning" - <<'PY' "$in" "$pw" "$enc"
import sys, binascii, hashlib
path = sys.argv[1]
pw_s = sys.argv[2]
enc = sys.argv[3]
pw = pw_s.encode(enc)
with open(path, "rb") as f:
    salt = f.read(16)
dk = hashlib.pbkdf2_hmac("sha256", pw, salt, 200000, dklen=48)
key = dk[:32]
iv  = dk[32:]
print(binascii.hexlify(key).decode(), binascii.hexlify(iv).decode())
PY
}

try_decrypt() {
  local enc="$1"
  read -r key_hex iv_hex < <(derive_key_iv "$enc")
  tail -c +17 "$in" | openssl enc -aes-256-cbc -d -K "$key_hex" -iv "$iv_hex" -out "$tmpzip"
}

# Ciphertext (ab Byte 17) mit OpenSSL entschluesseln -> ZIP
set +e
try_decrypt "utf-8"
rc=$?
if [[ $rc -ne 0 ]]; then
  try_decrypt "utf-16-le"
  rc=$?
fi
set -e

if [[ $rc -ne 0 ]]; then
  echo "Fehler: Entschluesselung fehlgeschlagen (UTF-8 und UTF-16LE probiert)." >&2
  exit $rc
fi

# ZIP entpacken
unzip -oq "$tmpzip" -d "$outdir"

rm -f "$tmpzip"
echo "OK: entpackt nach: $outdir"
