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
        "org.chromium.Chromium"
        "org.gnome.baobab"
        "org.prismlauncher.PrismLauncher"
        "com.github.tchx84.Flatseal"
        "org.fedoraproject.MediaWriter"
      ];

      overrides = {
        "org.signal.Signal".Environment = {
          SIGNAL_PASSWORD_STORE = "gnome-libsecret";
        };
      };

      update.onActivation = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-calculator
      eog
      mpv
      gnome-disk-utility
      gnome-text-editor
      solaar
      displaycal
      (pkgs.symlinkJoin {
        name = "seafile-client";
        paths = [pkgs.seafile-client];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/seafile-applet \
            --set QT_QPA_PLATFORMTHEME ""
        '';
      })
      seadrive-gui
    ];
  };
}
