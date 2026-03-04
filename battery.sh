#!/bin/bash  

status="$(acpi -b | awk '{print $3}' | tr -d ',')"
percentage="$(acpi -b | awk '{print $4}' | cut -d'%' -f1)"



if [ "$status" = "Discharging"  -a "$percentage" -lt 20 ] ; then
  notify-send -u critical "Battery  Low !"
  while [ "$(acpi -b | awk '{print $3}' | tr -d ',')" = "Discharging" ]
  do 
    master_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
    ((master_volume ++ )) 
    paplay --volume $(( 2000000 / $master_volume )) "$HOME/Music/sounds/beep.mp3"
  done 
# elif [ "$status" = "Charging" -a "$percentage" -ge 95 ]; then
#   notify-send "Battery charged" 
#     master_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
#     ((master_volume ++ )) 
#     paplay --volume $(( 2000000 / $master_volume )) "$HOME/Music/sounds/beep.mp3"
# elif [ "$status" = "Full" -a "$percentage" -eq 100 ]; then 
#   notify-send "Battery Full charged"
#     master_voluem=$(pactl get-sink-volume @DEFAULT_sINK@ | awk '{print $5}' | tr -d '%')
#     ((master_volume ++ ))
#     paplay --volume $(( 2000000 / $master_volume )) "$HOME/Music/sounds/beep.mp3"  
fi 


