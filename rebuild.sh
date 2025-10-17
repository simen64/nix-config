#!/bin/bash
set -e

export MACHINE="thinkpad"

git add *
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake /etc/nixos#${MACHINE} || exit 1
gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"
