{ inputs, lib, config, pkgs, ... }:

{ 
  dconf.settings = {
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };
    "org/gnome/desktop/background" = {
        "picture-uri-dark" = "/etc/nixos/wallpapers/japanese_store.jpg";
    };
    "org/gnome/desktop/screensaver" = {
        "picture-uri-dark" = "/etc/nixos/wallpapers/japanese_store.jpg";
    };
    "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "blur-my-shell@aunetx"
        ];
      };
  };
}
