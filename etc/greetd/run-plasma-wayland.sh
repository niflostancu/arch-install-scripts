#!/bin/bash
export XDG_SESSION_TYPE=wayland
exec /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland

