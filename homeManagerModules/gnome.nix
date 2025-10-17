{ pkgs, lib, ...}: {
  imports = [
    ./gnome-background.nix
    ./gnome-standard-settings.nix
  ];
}
