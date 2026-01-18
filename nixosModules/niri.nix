{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    niri = {
      enable = lib.mkEnableOption "Enable niri module";
    };
  };

  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;
    programs.niri.useNautilus = true;

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";

      configHome = "/home/simen";
    };

    environment.systemPackages = with pkgs; [
      wev
      wl-mirror
      brightnessctl
      gnome-keyring
      xwayland-satellite
      adwaita-icon-theme
      hicolor-icon-theme
      nautilus
      showtime
    ];

    services.gvfs.enable = true;
    services.devmon.enable = true;
    services.udisks2.enable = true;
  };
}
