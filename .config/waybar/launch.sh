#!/usr/bin/env sh

killall -q waybar

while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

if [[ $(hostname) == *"kohayakawa"* ]]; then
    waybar -c "$HOME/.config/waybar/config.laptop" -s "$HOME/.config/waybar/style.css" &
else
    waybar -c "$HOME/.config/waybar/config.desktop" -s "$HOME/.config/waybar/style.css" &
fi
