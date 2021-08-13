#!/usr/bin/env sh

FILE="$1"
HEAD_SIZE=$((256 * 1024))

if [ ! -f "$FILE" ]; then
  echo "usage: miaochuan [FILE]" >&2 && exit 1
fi

SIZE=$(wc -c "$FILE" | awk '{ print $1 }')

if [ "$SIZE" -lt $HEAD_SIZE ]; then
  echo "[FILE] size should be >= 256 KiB" >&2 && exit 1
fi

result=

if which md5sum >/dev/null 2>&1; then
  result=$(md5sum <"$FILE" | awk '{ print $1 }')
  result="$result#$(head -c $HEAD_SIZE "$FILE" | md5sum | awk '{ print $1 }')"
elif which md5 >/dev/null 2>&1; then
  result=$(md5 <"$FILE")
  result="$result#$(head -c $HEAD_SIZE "$FILE" | md5)"
else
  echo "md5sum/md5 not found" >&2 && exit 1
fi

result="$result#$SIZE"
result="$result#$(basename "$FILE")"

echo "$result"
