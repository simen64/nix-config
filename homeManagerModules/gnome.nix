{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome-wallpaper.nix
    ./gnome-standard-settings.nix
  ];

  options = {
    gnome = {
      enable = lib.mkEnableOption "Enable GNOME configuration";
    };
  };

  config = lib.mkIf config.gnome.enable {
    gnome-wallpaper.enable = lib.mkDefault true;
    gnome-standard-settings.enable = lib.mkDefault true;
  };
}
