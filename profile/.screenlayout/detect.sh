#!/bin/sh
xrandr --output VGA-1 --off --output LVDS-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-2 --off --output DP-1 --off 
xrandr --output VGA-1 --off --output LVDS-1 --primary --mode 1366x768 --pos 194x1080 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off &&
echo OK
