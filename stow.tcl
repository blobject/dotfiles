#! /usr/bin/env tclsh

cd [file dirname $::argv0]
exec stow {*}[glob _*]
