#!/usr/bin/env bash

WG=$(sudo wg)

if [ "$WG" = "" ]; then
    DRAWING=off
else
    DRAWING=on
fi

sketchybar --set "$NAME" drawing="$DRAWING"
