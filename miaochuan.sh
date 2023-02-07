#!/usr/bin/env sh

unset KEEP_PATH CD

error() { echo "$@" >&2; }

exist() { command -v "$1" >/dev/null 2>&1; }

if ! exist md5sum && ! exist md5; then
  error "miaochuan: md5sum/md5 not found"
  exit 127
fi

USAGE=$(
  cat <<-END
Usage: miaochuan [OPTION]... FILE...

  -k    keep relative path(s)
  -c    change to directory DIR
  -h    display this help and exit

Home page: <https://github.com/qianbinbin/miaochuan>
END
)

_exit() {
  error "$USAGE"
  exit 2
}

while getopts "khc:" c; do
  case $c in
  k) KEEP_PATH=true ;;
  c) CD=$OPTARG ;;
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
    error "miaochuan: Van!shment  Th!s World!!"
    exit 127
  fi
}

mc() {
  f=$(realpath --relative-to "$PWD" "$1")

  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    error "miaochuan: $f: Cannot access"
    return 1
  fi

  size=$(wc -c "$f" | awk '{ print $1 }')

  result=$(do_md5 <"$f")
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
