#!/bin/bash

export MACHINE="thinkpad"

pushd /etc/nixos/

#if git diff --quiet; then
#  echo "No changes detected, exiting."
#  popd
#  exit 0
#fi

#alejandra . &>/dev/null ||
#(
#  alejandra .
#  echo "formatting failed!" && exit 1
#)

git diff -U0

read -r -p "Commit message: " message

git add -A
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake /etc/nixos/#${MACHINE} &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

gen=$(nixos-rebuild list-generations | grep current)

git commit -am "$message | $gen"

popd

notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available

echo "done"
