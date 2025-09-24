#!/bin/sh

CHOICE=$(echo -e "⏾      Suspend\n      Reboot\n⏻      Shutdown" | fuzzel -d --hide-prompt -l 3 -w 12)

case "$CHOICE" in
    "⏾      Suspend") systemctl suspend ;;
    "      Reboot") systemctl reboot ;;
    "⏻      Shutdown") systemctl poweroff ;;
esac

