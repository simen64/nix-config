{ pkgs, lib, config, ... }: {

  options = {
    gnome-standard-settings = {
      enable = lib.mkEnableOption "Enable my opinionated standard settings for gnome";
    };
  };

  config = lib.mkIf config.gnome-standard-settings.enable {
    dconf.settings = {
      "org/gnome/desktop/datetime" = { automatic-timezone = true; };
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
  };
}
