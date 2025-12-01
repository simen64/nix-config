{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    autoUpgrade = {
      enable = lib.mkEnableOption "Enable auto upgrade module";
    };
  };

  config =
    lib.mkIf config.autoUpgrade.enable {
      system.autoUpgrade = {
        enable = true;
        flake = inputs.self.outPath;
        flags = [
          "--print-build-logs"
        ];
        dates = "12:00";
        randomizedDelaySec = "45min";
      };
    };
}
