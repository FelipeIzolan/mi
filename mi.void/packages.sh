#!/bin/bash

prompt() {
  echo -ne "$1 "
  read answer
  answer="${answer,,}" # to lowercase
  if [ -z $answer ] || [ $answer = "y" -o $answer = "yes" ]; then
    return 0
  fi
  return 1
}

queue=()
may_install() {
  if prompt "Install \e[4m$1\e[0m? [Y/n]"; then
    queue+=($1)
  fi
}

may_install ranger
may_install neovim
may_install chromium
may_install pulsemixer
may_install imv
may_install mpv

for package in "${queue[@]}"; do
  if [ $package = 'neovim' ] && prompt "> Use mi.nvim config? [Y/n]"; then
    mkdir -p ~/.config/nvim
    curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/FelipeIzolan/mi/refs/heads/main/mi.nvim/init.lua
  fi
  sudo xbps-install -y $package
  if [ $package = 'pulsemixer' ]; then
   echo -e "[Desktop Entry]\nExec=pulsemixer\nTerminal=true" | sudo tee /usr/share/applications/pulsemixer.desktop
  fi
  if [ $package = 'imv' ]; then
    xdg-mime default imv.desktop $(grep "^image/" /usr/share/mime/types)
  fi
  if [ $package = 'mpv' ]; then
    xdg-mime default mpv.desktop $(grep "^video/" /usr/share/mime/types)
    xdg-mime default mpv.desktop $(grep "^audio/" /usr/share/mime/types)
  fi
done
