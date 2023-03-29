Introduction
============

Rover is a file browser for the terminal.

![Rover screenshot](/../screenshots/screenshot.png?raw=true "Screenshot")

The main goal is to provide a faster way to explore a file system from the 
terminal, compared to what's possible by using `cd`, `ls`, etc. Rover has 
vi-like key bindings for navigation and can open files in $PAGER and $EDITOR. 
Basic file system operations are also implemented (see rover(1) for details). 
Rover is designed to be simple, fast and portable.

Quick Start
===========

Building and Installing:
```
$ make
$ sudo make install
```

Running:
```
$ rover [DIR1 [DIR2 [DIR3 [...]]]]
```

Basic Usage:
```
             q - quit Rover
             ? - show Rover manual
   j,DOWN/k,UP - move cursor down/up
           J/K - move cursor down/up 10 lines
           g/G - move cursor to top/bottom of listing
l,RIGHT,RETURN - enter selected directory
        h,LEFT - go to parent directory
             H - go to $HOME directory
           0-9 - change tab
             S - open $SHELL (Terminal) on the current directory
         SPACE - open $PAGER with the selected file
             e - open $VISUAL or $EDITOR with the selected file
             / - start incremental search (RETURN to finish)
           n/N - create new file/directory
             R - rename selected file or directory
             D - delete selected file or (empty) directory
```

Please read rover(1) for more information.

Requirements
============

- Unix-like system
- curses library

Configuration
=============

Rover configuration (mostly key bindings and colors) can only be changed by 
editing the file `config.h` and rebuilding the binary.

Note that the external programs executed by some Rover commands may be changed 
via the appropriate environment variables. For example, to specify an editor:
```
$ VISUAL=vi rover
```

Rover will first check for variables prefixed with ROVER_. This can be used to 
change Rover behavior without interfering with the global environment:
```
$ ROVER_VISUAL=vi rover
```

Please read rover(1) for more information.

Examples
========
```
export ROVER_VISUAL=vim
export ROVER_OPEN=~/code/rover/open.sh
export ROVER_PAGER="less 2> /dev/null -N"
export ROVER_SHELL="sh -c 'echo \"Type EXIT to return to Windows 95\"; exec \"${SHELL:-sh}\"'"
```

Frequently Asked Questions
==========================

How to use Rover to change the current directory of a shell?
------------------------------------------------------------

Rover cannot change the working directory of its calling shell directly.
However, we can use the option `--save-cwd` to write the last visited path
to a temporary file. Then we can `cd` to that path from the shell itself.

The following shell script can be used to automate this mechanism.
Note that it needs to be sourced directly from the shell.

```
#! /bin/sh

# Based on ranger launcher.

# Usage:
#     source ./cdrover.sh [/path/to/rover]

tempfile="$(mktemp 2> /dev/null || printf "/tmp/rover-cwd.%s" $$)"

if [ $# -gt 0 ]; then
    rover="$1"
    shift
else
    rover="rover"
fi
"$rover" --save-cwd "$tempfile" "$@"
returnvalue=$?
test -f "$tempfile" &&
if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd "$(cat "$tempfile")"
fi
rm -f -- "$tempfile"
return $returnvalue
```

How to open files with appropriate applications?
------------------------------------------------

Rover doesn't have any built-in functionality to associate file types with
applications. This is delegated to an external tool, designated by the
environmental variable `$ROVER_OPEN`. This tool must be a command that
takes a filename as argument and runs the appropriate program, opening the
given file.

As an example, the following shell script may be used as `$ROVER_OPEN`:

```
#! /bin/sh

# Usage:
#     ./open.sh /path/to/file

case "$1" in
  *.htm|*.html)
    fmt="elinks %s" ;;
  *.pdf|*.xps|*.cbz|*.epub)
    fmt="mutool draw -F txt %s | less" ;;
  *.ogg|*.flac|*.wav|*.mp3)
    fmt="play %s" ;;
  *.[1-9])
    fmt="man -l %s" ;;
  *.c|*.h|*.sh|*.lua|*.py|*.ml|*[Mm]akefile)
    fmt="vim %s" ;;
  *)
    fmt="less %s"
esac

exec sh -c "$(printf "$fmt" "\"$1\"")"
```

Copying
=======

All of the source code and documentation for Rover is released into the public
domain and provided without warranty of any kind.
