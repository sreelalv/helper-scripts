#! /bin/bash
echo "$(whoami) $(date)"

powerOff(){
  list=(
    brave
    discord
    spotify
    telegram-desktop
    notion-app
    )

  for item in ${list[@]}
  do 
    timeout 10s killall -15 -w $item 
    if [ $? -eq 0 ] ; then
      echo "killed $item"
    fi
  done 
}

powerOff
sleep 5
echo "Termination completed"

