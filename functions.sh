#!/bin/bash

export PATH=$PATH:$HOME/scripts
project_path="$HOME/Documents/Projects/"

background(){
  (( "$@" >/dev/null 2>&1 && [[ $? -eq 0 ]] && (notify-send "Task Completed" "$*") || (notify-send "Task Failed" "$*") )&)
}

quiet(){
  ("$@" >/dev/null 2>&1)
}

run(){
  (("$@" > /dev/null  2>&1 )&) 
}


bl(){        #Bluetooth control 
  if [ -z $1 ] ; then 
    bluetoothctl devices |grep --colour=never Device | awk 'BEGIN{i=1}{print i" "$0 ;i++}'
  else 
    if [ "$1" = "dis" -o "$1" = "disconnect" ] ; then
      quiet bluetoothctl disconnect
    elif [ "$1" = "scan" ] ; then
      ((expect -c '
      spawn bluetoothctl 
      set timeout 0
      expect "#"
      send "scan on\r"
      set timeout 5
      expect "#"
      send "exit\r"
      ' >/dev/null 2>&1)&& bl)
    elif [ "$1" = "i" -o "$1" = "interactive" ] ; then 
      bluetoothctl 
    else
      if [[ "$1" =~ "[0-9]" ]]; then
        device="$(bluetoothctl devices | awk -v value="$1" 'NR==value{print $2}')"
        echo "$device"
      else
        device="$(bluetoothctl devices | grep -i "$1" | awk '{print $2}')" 
        if [[ -z "$device" ]] ; then 
          echo "No device found" 
          exit 
        fi
      fi

      if [[ "$(bluetoothctl info $device | grep Trusted | awk '{print $2}')" == "no" ]] ;then
        quiet bluetoothctl pair "$device"
        quiet bluetoothctl trust "$device" 
      fi
      quiet bluetoothctl connect "$device"
    fi 
  fi 
}

bri(){        # Brightness control 
  current="$(brightnessctl i | awk 'NR==2{print $3/120000*100}')"
  val="$1"

  if [[ -z $val ]] ; then 
    echo "Brightness set $current%" 
  else 
    if [[ "$val" =~ ^[0-9]+$ ]] ;then 
    : 
    elif [[ "$val" =~ ^[+][0-9]+$ ]]; then
      (( val = current + val )) 
    elif [[ "$val" =~ ^[-][0-9]+$ ]]; then 
      val="$(echo $val | tr -d '-')" 
      (( val = current - val ))  
    fi 
    if [[ $val -lt 5 ]]; then 
      ((val = 5))
    fi
    brightnessctl set "$val%" > /dev/null && echo "$(bri)"
  fi
}

p(){      #Project
  if [[ -z $1 ]] ; then 
    ls $project_path
  else
    if [[ $(ls $project_path | grep $1 ) ]] ; then 
      cd "$project_path$1" && ls
    else
      echo "Project $1 not found"
    fi
  fi
}



