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
      nmap
      go
      unzip
      bind
      python3
      uv
      age-plugin-yubikey
      opencode
      github-copilot-cli
    ];
  };
}
