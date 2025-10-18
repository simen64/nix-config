{ pkgs, lib, config, ... }: {

  options = {
    gnome-wallpaper = {
      enable = lib.mkEnableOption "Enable my preferred standard wallpaper";
    };
  };

  config = lib.mkIf config.gnome-wallpaper.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        "picture-uri-dark" = "/etc/nixos/wallpapers/japanese_store.jpg";
      };
      "org/gnome/desktop/screensaver" = {
        "picture-uri-dark" = "/etc/nixos/wallpapers/japanese_store.jpg";
      };
    }; 
  };
}
