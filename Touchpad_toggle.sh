#!/bin/bash

notif="$HOME/.config/swaync/images/ja.png"

export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enableTouchpad(){
  printf "true" > "$STATUS_FILE"
  notify-send -u low -i $notif " Enabling" " touchpad "
  hyprctl keyword 'device[elan1203:00-04f3:307a-touchpad]:enabled' true
}


disableTouchpad(){
  printf "false" > "$STATUS_FILE"
  notify-send -u low -i $notif " Disabling" " touchpad "
  hyprctl keyword 'device[elan1203:00-04f3:307a-touchpad]:enabled' false
}

if ! [ -f "$STATUS_FILE" ]; then
  disableTouchpad
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disableTouchpad
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enableTouchpad
  fi
fi
