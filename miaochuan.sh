#!/usr/bin/env sh

HEAD_SIZE=$((256 * 1024))

unset KEEP_PATH CD SHORT

SCRIPT=$(basename "$0")

error() { echo "$@" >&2; }

exist() { command -v "$1" >/dev/null 2>&1; }

if ! exist md5sum && ! exist md5; then
  error "$SCRIPT: md5sum/md5 not found"
  exit 127
fi

USAGE=$(
  cat <<-END
Usage: $SCRIPT [<options>] <path>...
Print miaochuan code of file(s).

  -k            keep relative path(s)
  -c <dir>      change the directory before printing
  -s            print short miaochuan code
  -h            display this help and exit

Home page: <https://github.com/qianbinbin/miaochuan>
END
)

_exit() {
  error "$USAGE"
  exit 2
}

while getopts "khsc:" c; do
  case $c in
  k) KEEP_PATH=true ;;
  c) CD=$OPTARG ;;
  s) SHORT=true ;;
  h) error "$USAGE" && exit ;;
  *) _exit ;;
  esac
done

if [ -n "$CD" ]; then
  cd "$CD" || exit 1
fi

shift $((OPTIND - 1))

[ $# -eq 0 ] && _exit

do_md5() {
  if exist md5sum; then
    md5sum | awk '{ print $1 }'
  elif exist md5; then
    md5
  else
    error "$SCRIPT: Van!shment  Th!s World!!"
    exit 127
  fi
}

mc() {
  f=$(realpath --relative-to "$PWD" "$1")

  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    error "$SCRIPT: $f: Cannot access"
    return 1
  fi

  size=$(wc -c "$f" | awk '{ print $1 }')

  if [ "$SHORT" != true ] && [ "$size" -lt $HEAD_SIZE ]; then
    error "$SCRIPT: $file: Size must be >= 256 KiB"
    return 1
  fi

  result=$(do_md5 <"$f")
  if [ "$SHORT" != true ]; then
    result="$result#$(head -c $HEAD_SIZE "$file" | do_md5)"
  fi
  result="$result#$size"
  if [ "$KEEP_PATH" = true ]; then
    _f="$f"
  else
    _f=$(basename "$f")
  fi
  result="$result#$_f"

  echo "$result"
}

find "$@" -type f | while IFS= read -r file; do
  mc "$file"
done
