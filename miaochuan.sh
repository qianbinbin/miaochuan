#!/usr/bin/env sh

HEAD_SIZE=$((256 * 1024))

error() {
  echo "$@" >&2
}

if [ $# -eq 0 ]; then
  error "Usage: miaochuan FILE ..."
  exit 2
fi

exist() {
  which "$1" >/dev/null 2>&1
}

if ! exist md5sum && ! exist md5; then
  error "miaochuan: md5sum/md5 not found"
  exit 127
fi

do_md5() {
  if exist md5sum; then
    md5sum | awk '{ print $1 }'
  elif exist md5; then
    md5
  else
    error "miaochuan: Van!shment  Th!s World!!"
    exit 127
  fi
}

mc() {
  file="$1"

  if [ ! -f "$file" ] || [ ! -r "$file" ]; then
    error "miaochuan: $file: Cannot access"
    return 1
  fi

  size=$(wc -c "$file" | awk '{ print $1 }')

  if [ "$size" -lt $HEAD_SIZE ]; then
    error "miaochuan: $file: Size must be >= 256 KiB"
    return 1
  fi

  result=$(do_md5 <"$file")
  result="$result#$(head -c $HEAD_SIZE "$file" | do_md5)"
  result="$result#$size"
  result="$result#$(basename "$file")"

  echo "$result"
}

for file in "$@"; do
  mc "$file"
done
