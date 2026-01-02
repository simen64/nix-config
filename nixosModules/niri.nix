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
    ];
  };
}
