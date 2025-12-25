{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktop-apps = {
      enable = lib.mkEnableOption "Enable desktop-apps module";
    };
  };

  config = lib.mkIf config.desktop-apps.enable {
    programs.firefox.enable = true;

    services.flatpak = {
      enable = true;

      packages = [
        "com.spotify.Client"
        "im.riot.Riot"
        "org.onlyoffice.desktopeditors"
        "dev.vencord.Vesktop"
        "org.signal.Signal"
      ];

      overrides = {
        "org.signal.Signal".Environment = {
          SIGNAL_PASSWORD_STORE = "gnome-libsecret";
        };
      };

      update.onActivation = true;
    };
  };
}
