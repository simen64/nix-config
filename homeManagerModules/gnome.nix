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
  };
}
