#!/bin/bash

get_ram() {
  if ! command -v free >/dev/null 2>&1; then
    echo ""
    return 0
  fi
  TOTAL_RAM=$(free -mh --si | awk '{print $2}' | head -n 2 | tail -1)
  USED_RAM=$(free -mh --si | awk '{print $3}' | head -n 2 | tail -1)
  echo "$USED_RAM/$TOTAL_RAM"
}

get_time() {
  echo "$(date +"%I:%M%p")"
}

while true; do
  ram="$(get_ram)"
  time="$(get_time)"
  xsetroot -name "[$ram RAM][$time]"
  sleep 15s
done
