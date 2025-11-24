#!/usr/bin/env bash
set -euo pipefail

read -r NAME WIDTH HEIGHT X Y SCALE CURRENT_RATE <<< "$(hyprctl -j monitors | jq -r '.[] | select(.name | test("eDP-[0-9]+")) | "\(.name) \(.width) \(.height) \(.x) \(.y) \(.scale) \(.refreshRate)"' | head -n 1)"

if [[ -z "$NAME" ]]; then
    notify-send "No eDP monitor found."
    exit 1
fi

if (( $(echo "$CURRENT_RATE < 61" | bc -l) )); then
    NEW_RATE="360"
else
    NEW_RATE="60"
fi

NEW_CONFIG="$NAME,${WIDTH}x${HEIGHT}@$NEW_RATE,${X}x${Y},$SCALE"

if hyprctl keyword monitor "$NEW_CONFIG"; then
    notify-send -t 2000 "${NEW_RATE}Hz active on $NAME"
else
    notify-send -u critical "Could not apply ${NEW_RATE}Hz"
    exit 1
fi
