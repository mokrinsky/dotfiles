#!/usr/bin/env bash

TEMP=$(osx-cpu-temp)

sketchybar --set "$NAME" label="$TEMP"
