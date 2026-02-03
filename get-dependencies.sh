#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu      \
    libdecor \
    libvpx   \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Rednukem..."
echo "---------------------------------------------------------------"
REPO="https://github.com/NBlood/NBlood"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./NBlood
echo "$VERSION" > ~/version

cd ./NBlood
make rednukem -j$(nproc)
install -D -t /usr/bin rednukem
install -D -t /usr/share/games/rednukem -m 644 dn64widescreen.pk3
install -D -t /usr/share/licenses/rednukem -m 644 package/common/buildlic.txt
install -Dm644 source/blood/rsrc/game_icon.ico /usr/share/pixmaps/rednukem.ico
