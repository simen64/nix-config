{ pkgs, lib, config, ... }: {

  options = {
    module = {
      enable = lib.mkEnableOption "Enable module";
    };
  };

  config = lib.mkIf config.module.enable {

  };
}
