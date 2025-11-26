#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  export MACHINE="macbook"
  pushd ~/nix/
else
  export MACHINE="thinkpad"
  pushd /etc/nixos
fi

if git diff --quiet; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

alejandra .

git diff -U0

# Check if a commit message was provided as an argument
if [ -n "$1" ]; then
  message="$1"
  echo "Using provided commit message: $message"
else
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
fi

git add -A

echo "NixOS Rebuilding..."

if [[ "$OSTYPE" == "darwin"* ]]; then
  sudo echo "Authentication complete" && sudo darwin-rebuild switch --flake /Users/simen/nix#${MACHINE}
  rebuild_status=$?
  gen=$(sudo darwin-rebuild --list-generations | grep current)
else
  sudo echo "Authentication complete" && sudo nixos-rebuild switch --flake /etc/nixos/#${MACHINE}
  rebuild_status=$?
  gen=$(nixos-rebuild list-generations | grep current)
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  osascript -e 'display notification "Nix rebuild finnished successfully" with title "Nix rebuild"'
else
  notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
fi

echo "commiting: ${message} | ${gen}"
git commit -am "${message} | ${gen}"

echo "pushing"
git push

popd

echo "done"
