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

    environment.systemPackages = with pkgs; [
      wl-mirror
      gnome-keyring
    ];
  };
}
