#!/bin/sh

# Usage:
#     ./open.sh /path/to/file

case "$1" in
  *.htm|*.html)
    fmt="w3m %s" ;;
  *.pdf|*.xps|*.cbz|*.epub)
    fmt="mutool draw -F txt %s | less" ;;
  *.ogg|*.flac|*.wav|*.mp3)
    fmt="play %s" ;;
  *.[1-9])
    fmt="man -l %s" ;;
  *.bac|*.c|*.h|*.sh|*.lua|*.py|*.ml|*[Mm]akefile)
    fmt="vim %s" ;;
  *.md|*.mkd)
    #fmt="pandoc -t plain %s | less" ;;
    fmt="lowdown -Tterm %s | less -R" ;;
  *)
    fmt="less %s"
esac

exec sh -c "$(printf "$fmt" "\"$1\"")"
