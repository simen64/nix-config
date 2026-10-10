{
  pkgs,
  lib,
  config,
  ...
}: let
  # DaVinci Resolve's resizable Project Manager dialog is otherwise
  # misclassified as a popup and never appears under niri.
  # https://github.com/Supreeeme/xwayland-satellite/pull/480
  xwaylandSatelliteResolve = pkgs.xwayland-satellite.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (pkgs.fetchpatch {
          url = "https://github.com/lildengzi/xwayland-satellite/commit/a8f8eeac96d7f5b6e83a49ebd7f294e9a3879f22.patch";
          hash = "sha256-79Oza6gwuWvOH5GTsD8ujEDENf0buofOZwwRwdTagQw=";
        })
      ];
  });
in {
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

    users.users.simen = {
      isNormalUser = true;
      extraGroups = ["greeter"];
    };

    environment.systemPackages = with pkgs; [
      wev
      wl-mirror
      brightnessctl
      gnome-keyring
      #xwaylandSatelliteResolve
      adwaita-icon-theme
      hicolor-icon-theme
      nautilus
      showtime
    ];

    services.gvfs.enable = true;
    services.devmon.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config = {
        common.default = ["gnome"];
      };
    };
  };
}
