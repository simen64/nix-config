{ pkgs, lib, config, ... }: {

  options = {
    git = {
      enable = lib.mkEnableOption "Enable git module";
    };
  };

  config = lib.mkIf config.git.enable {
    services = {
      ssh-tpm-agent = mkIf stdenv.isLinux {
      enable = true;
    };

    programs.git = {
      enable = true;
      userEmail = "simenmunch@gmail.com";
      userName = "simen64";
    };
  };
}
