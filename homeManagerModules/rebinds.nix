{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    rebinds = {
      enable = lib.mkEnableOption "Enable keyboard rebinds";
    };
  };

  config = lib.mkIf config.rebinds.enable {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:escape"];
      };
    };
  };
}
