#!/bin/bash

get_ram() {
  if ! command -v free >/dev/null 2>&1; then
    echo ""
    return 0
  fi
  TOTAL_RAM=$(free -mh --si | awk '{print $2}' | head -n 2 | tail -1)
  USED_RAM=$(free -mh --si | awk '{print $3}' | head -n 2 | tail -1)
  echo "$USED_RAM/$TOTAL_RAM RAM"
}

while true; do
  xsetroot -name "[$(get_ram)][$(date +'%I:%M%p')][$(date '+%d-%m-%y(%a)')]"
  sleep 15s
done
