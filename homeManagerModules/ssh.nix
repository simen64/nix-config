{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh module";
    };
  };

  config = lib.mkIf config.ssh.enable {
    home.packages = with pkgs; [
      openssh
    ];
  };
}
