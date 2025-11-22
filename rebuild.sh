#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  export MACHINE="macbook"
  pushd ~/nix/
else
  pushd /etc/nixos
fi

if git diff --quiet; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

alejandra .

git diff -U0

diff=$(git diff -U0)

message=$(qwen -p "Using this git diff create a one sentence git commit message. ALWAYS follow conventional commits. ONLY output the commit message nothing else. Keep the language simple. Git diff: ${diff}")

while true; do
  read -rp "Use '${message}'? [y/n]: " answer
  case "$answer" in
  [Yy] | [Yy][Ee][Ss])
    echo "You chose YES"
    break
    ;;
  [Nn] | [Nn][Oo])
    echo "You chose NO"
    read -r -p "Custom commit message: " message
    break
    ;;
  *)
    echo "Please answer y or n."
    ;;
  esac
done

git add -A

echo "NixOS Rebuilding..."

if [[ "$OSTYPE" == "darwin"* ]]; then
  sudo echo "Authentication complete" && sudo darwin-rebuild switch --flake /Users/simen/nix#${MACHINE} &>nixos-switch.log
  rebuild_status=$?
else
  sudo echo "Authentication complete" && sudo nixos-rebuild switch --flake /etc/nixos/#${MACHINE} &>nixos-switch.log
  rebuild_status=$?
fi

if [ $rebuild_status -ne 0 ]; then
  cat nixos-switch.log | grep --color error
  exit 1
fi

gen=$(nixos-rebuild list-generations | grep current)

git commit -am "${message} | ${gen}"
git push

popd

if [[ "$OSTYPE" == "darwin"* ]]; then
  osascript -e 'display notification "Nix rebuild finnished successfully" with title "Nix rebuild"'
else
  notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
fi

echo "done"
