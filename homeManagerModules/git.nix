{ pkgs, lib, config, ... }: {

  options = {
    git = {
      enable = lib.mkEnableOption "Enable git module";
    };
  };

config = lib.mkIf config.git.enable ({
    programs.git = {
      enable = true;
      userEmail = "simenmunch@gmail.com";
      userName = "simen64";
    };

    home.packages = lib.mkIf pkgs.stdenv.isLinux [
      pkgs.ssh-tpm-agent
    ];

    services.ssh-tpm-agent.enable=true;
  }
);
}
