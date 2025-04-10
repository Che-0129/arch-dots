#!/bin/fish
swayidle -w timeout 530 'brightnessctl -s set 10' \
    resume 'brightnessctl -r' \
    timeout 600 'swaylock --image $(find /usr/share/backgrounds/archlinux/ -maxdepth 1 -type f | shuf -n 1) -f -e --indicator-idle-visible --ring-color 595959 --key-hl-color 26d9e6' \
    timeout 720 'systemctl suspend' \
    before-sleep 'playerctl pause; swaylock --image $(find /usr/share/backgrounds/archlinux/ -maxdepth 1 -type f | shuf -n 1) -f -e --indicator-idle-visible --ring-color 595959 --key-hl-color 26d9e6'
