{ pkgs, lib, config, ... }: {

  options = {
    git = {
      enable = lib.mkEnableOption "Enable git module";
    };
  };

config = lib.mkIf config.git.enable ({
    programs.git = {
      enable = true;
      settings = {
        user.email = "simenmunch@gmail.com";
        user.name = "simen64";
      };
    };

    services = {
      ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
      ssh-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
    };

  }
);
}
