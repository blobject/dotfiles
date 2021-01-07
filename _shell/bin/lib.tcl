#! /usr/bin/env tclsh

set ME [file tail $::argv0]
set TMPD "/tmp/_$::env(USER)"

proc err {s} { global ME; puts stderr "$ME: $s" }
proc fail {s} { err $s; exit 1 }
proc need {args} {
  foreach cmd $args {
    if [catch {exec which $cmd}] { fail "need $cmd" }
  }
}
