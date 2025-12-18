{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    dev = {
      enable = lib.mkEnableOption "Enable dev module";
    };
  };

  config = lib.mkIf config.dev.enable {
    home.packages = with pkgs; [
      devenv
      go
    ];
  };
}
