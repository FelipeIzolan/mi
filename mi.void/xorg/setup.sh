cat << 'EOF'

| mi.void           |
| *xorg + suckless* |

EOF

read -p "- Graphics Driver -"$'\n\n'" 0: Intel"$'\n'" 1: AMD"$'\n\n'"Enter: " driver

if [ $driver -ne "0" -a $driver -ne "1" ]; then
  echo "Invalid: $driver"
  exit
fi

sudo xbps-install -Sy

sudo xbps-install -y linux-firmware-$([[ $driver =  "0" ]] && echo "intel" || echo "amd") mesa-dri

sudo xbps-install -y dbus\
                     elogind\
                     polkit\
                     pipewire\
                     wireplumber

sudo xbps-install -y xorg-minimal\
                     xclip\
                     xwallpaper\
                     xsetroot\
                     setxkbmap\
                     libX11\
                     libXft\
                     libXinerama\
                     freetype\
                     fontconfig\
                     base-devel\
                     libX11-devel\
                     libXft-devel\
                     libXinerama-devel\
                     freetype-devel\
                     fontconfig-devel\
                     xdg-user-dirs\
                     curl

curl https://dl.suckless.org/dwm/dwm-6.8.tar.gz -o ./suckless/dwm-6.8.tar.gz
curl https://dl.suckless.org/st/st-0.9.3.tar.gz -o ./suckless/st-0.9.3.tar.gz
curl https://dl.suckless.org/tools/dmenu-5.4.tar.gz -o ./suckless/dmenu-5.4.tar.gz

tar -xzf ./suckless/dwm-6.8.tar.gz -C ./suckless
tar -xzf ./suckless/st-0.9.3.tar.gz -C ./suckless
tar -xzf ./suckless/dmenu-5.4.tar.gz -C ./suckless

DWM=(
  "https://dwm.suckless.org/patches/vanitygaps/dwm-cfacts-vanitygaps-6.4_combo.diff"
  "https://dwm.suckless.org/patches/cyclelayouts/dwm-cyclelayouts-20180524-6.2.diff"
  "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff"
)

ST=(
  "https://st.suckless.org/patches/glyph_wide_support/st-glyph-wide-support-20230701-5770f2f.diff"
  "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff"
  "https://st.suckless.org/patches/scrollback/st-scrollback-0.9.2.diff"
  "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-0.9.2.diff"
)

for value in ${DWM[@]}; do
  curl -q ${value} | patch -d ./suckless/dwm-6.8 -i -
done

for value in ${ST[@]}; do
  curl -q ${value} | patch -d ./suckless/st-0.9.3 -i -
done

cp -vf ./suckless/dwm.config.h ./suckless/dwm-6.8/config.h
cp -vf ./suckless/st.config.h ./suckless/st-0.9.3/config.h
cp -vf ./suckless/dmenu.config.h ./suckless/dmenu-5.4/config.h

sudo make -C ./suckless/dwm-6.8 clean install
sudo make -C ./suckless/st-0.9.3 clean install
sudo make -C ./suckless/dmenu-5.4 clean install

sudo ln -s /etc/sv/dbus /var/service
sudo rm /var/service/acpid
sudo rm /var/service/sshd

xdg-user-dirs-update

rm -rf ./suckless/dwm-6.8
rm -rf ./suckless/st-0.9.3
rm -rf ./suckless/dmenu-5.4
rm -f ./suckless/dwm-6.8.tar.gz
rm -f ./suckless/st-0.9.3.tar.gz
rm -f ./suckless/dmenu-5.4.tar.gz

sudo xbps-remove -Ry base-devel\
                     libX11-devel\
                     libXft-devel\
                     libXinerama-devel\
                     freetype-devel\
                     fontconfig-devel\
                     xdg-user-dirs\
                     curl
sudo xbps-remove -Oyo
 
mkdir -p ~/.cache
mkdir -p ~/.local/share/fonts
sudo mkdir -p /etc/pipewire/pipewire.conf.d

cp -fv ./resources/.xinitrc ~/.xinitrc
cp -fv ./resources/statusbar.sh ~/statusbar.sh
cp -fv ./resources/wallpaper.png ~/wallpaper.png
cp -fv ./resources/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf

sudo chmod -R 777 ~/.cache
sudo chmod +x ~/statusbar.sh

sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
