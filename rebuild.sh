#!/usr/bin/env bash

SKIP_DIFF_CHECK=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -f | --force)
    SKIP_DIFF_CHECK=true
    shift
    ;;
  *)
    # Assume the first non-flag argument is the commit message
    break
    ;;
  esac
done

HOSTNAME=$(hostname)

if [[ "$OSTYPE" == "darwin"* ]]; then
  export MACHINE="macbook"
  pushd ~/nix/

elif [[ "$HOSTNAME" == "simens-laptop" ]]; then
  esport MACHINE="thinkpad"
  pushd /etc/nixos/
elif [[ "$HOSTNAME" == "desktop-p" ]]; then
  export MACHINE="desktop-p"
  pushd /etc/nixos/
else
  read -r -p "enter MACHINE: " MACHINE
fi

echo $MACHINE

if [[ "$SKIP_DIFF_CHECK" == false ]] && git diff --quiet; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

alejandra .

git diff -U0

# Check if a commit message was provided as an argument (after flags have been processed)
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
  sudo echo "Authentication complete" && sudo darwin-rebuild switch --flake /Users/simen/nix#${MACHINE} ||
    git restore --staged . &&
    exit 1
  rebuild_status=$?
  gen=$(sudo darwin-rebuild --list-generations | grep current | sed 's/   (current)$//')
else
  sudo echo "Authentication complete" && sudo nixos-rebuild switch --flake /etc/nixos/#${MACHINE} ||
    git restore --staged . &&
    exit 1
  rebuild_status=$?
  gen=$(nixos-rebuild list-generations | grep current | sed 's/   (current)$//')
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  osascript -e 'display notification "Nix rebuild finnished successfully" with title "Nix rebuild"'
else
  notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
fi

echo "commiting: ${message} | ${MACHINE}: ${gen}"
git commit -am "${message} | ${MACHINE}: ${gen}"

echo "pushing"
git push

popd

echo "done"
