queue=()

prompt() {
  read -p "${1}" answer
  answer="${answer,,}" # to lowercase
  if [ -z $answer ] || [ $answer = "y" -o $answer = "yes" ]; then
    return 0
  fi
  return 1
}

may_install() {
  if prompt "> Install $1? [Y/n] "; then
    queue+=($1)
  fi
}

may_install ranger
may_install imv
may_install mpv
may_install neovim
may_install chromium
may_install pulsemixer

for package in "${queue[@]}"; do
  if [ $package = 'neovim' ] && prompt "> Use mi.nvim config? [Y\n] "; then
    mkdir -p ~/.config/nvim
    curl https://raw.githubusercontent.com/FelipeIzolan/mi/refs/heads/main/mi.nvim/init.lua > ~/.config/nvim/init.lua
  fi
  sudo xbps-install -y $package
  if [ $package = 'imv' ]; then
    xdg-mime default imv.desktop $(grep "^image/" /usr/share/mime/types)
  fi
  if [ $package = 'mpv' ]; then
    xdg-mime default mpv.desktop $(grep "^video/" /usr/share/mime/types)
    xdg-mime default mpv.desktop $(grep "^audio/" /usr/share/mime/types)
  fi
done
