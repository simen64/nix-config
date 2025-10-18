{ pkgs, lib, ...}: {
  imports = [
    ./gnome-wallpaper.nix
    ./gnome-standard-settings.nix
  ];

  gnome-standard-settings.enable = lib.mkDefault true;
  gnome-wallpaper.enable = lib.mkDefault true;
}
