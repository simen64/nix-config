{ pkgs, lib, config, ... }: {

  options = {
    gnome = {
      enable = lib.mkEnableOption "Enable GNOME configuration";
    };
  };

  config = lib.mkIf config.gnome.enable {
    imports = [
      ./gnome-wallpaper.nix
      ./gnome-standard-settings.nix
    ];

    gnome.gnome-standard-settings.enable = lib.mkDefault true;
    gnome.gnome-wallpaper.enable = lib.mkDefault true;
  };
}
