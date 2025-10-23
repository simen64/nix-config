#!/bin/bash
set -e

export MACHINE="thinkpad"

pushd /etc/nixos/

if git diff --quiet '*.nix'; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

#alejandra . &>/dev/null ||
#(
#  alejandra .
#  echo "formatting failed!" && exit 1
#)

git diff -U0

read -r -p "Commit message: " message

git add *
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake /etc/nixos#${MACHINE}
gen=$(nixos-rebuild list-generations | grep current)
echo "comitting"
git commit -am "$message | $gen"
