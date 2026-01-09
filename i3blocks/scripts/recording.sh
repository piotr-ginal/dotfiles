#!/bin/bash

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/wf-recorder.pid"

if [ -f "$PIDFILE" ]; then
    echo "<span background='#ff0000' foreground='#ffffff'><i> RECORDING </i></span>"
    exit 0
fi
