{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    podman = {
      enable = lib.mkEnableOption "Enable podman module";
    };
  };

  config = lib.mkIf config.podman.enable {
    services.podman = {
      enable = true;
    };
  };
}
