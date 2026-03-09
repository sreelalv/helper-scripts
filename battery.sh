#!/bin/bash  

status="$(acpi -b | awk '{print $3}' | tr -d ',')"
percentage="$(acpi -b | awk '{print $4}' | cut -d'%' -f1)"



if [[ "$status" = "Discharging" && "$percentage" -lt 90 ]] ; then
  notify-send -u critical "Battery  Low !"
  while [ "$(acpi -b | awk '{print $3}' | tr -d ',')" = "Discharging" ]
  do 
    master_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
    ((master_volume ++ )) 
    beep >/dev/null 2>&1 || canberra-gtk-play -i dialog-warning >/dev/null 2>&1 || paplay --volume $(( 2000000 / $master_volume )) "$HOME/Music/sounds/beep.mp3" /dev/null 2>&1
  done  
fi 


