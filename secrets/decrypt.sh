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

# Key/IV ableiten (PBKDF2-HMAC-SHA256, 200000 Iterationen, Salt=erste 16 Bytes, dkLen=48 => 32 Key + 16 IV)
read -r key_hex iv_hex < <(
python3 - <<'PY' "$in" "$pw"
import sys, binascii, hashlib
path = sys.argv[1]
pw = sys.argv[2].encode("utf-16-le")
with open(path, "rb") as f:
    salt = f.read(16)
dk = hashlib.pbkdf2_hmac("sha256", pw, salt, 200000, dklen=48)
key = dk[:32]
iv  = dk[32:]
print(binascii.hexlify(key).decode(), binascii.hexlify(iv).decode())
PY
)

# Ciphertext (ab Byte 17) mit OpenSSL entschluesseln -> ZIP
tail -c +17 "$in" | openssl enc -aes-256-cbc -d -K "$key_hex" -iv "$iv_hex" -out "$tmpzip"

# ZIP entpacken
unzip -oq "$tmpzip" -d "$outdir"

rm -f "$tmpzip"
echo "OK: entpackt nach: $outdir"
