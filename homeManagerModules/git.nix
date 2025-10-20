{ pkgs, lib, config, ... }: {

  options = {
    git = {
      enable = lib.mkEnableOption "Enable git module";
    };
  };

  config = lib.mkIf config.git.enable {
    inherit (lib.mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        ssh-tpm-agent
      ];

      services = {
        ssh-tpm-agent = {
          enable = true;
        };
      };
    });

    programs.git = {
      enable = true;
      userEmail = "simenmunch@gmail.com";
      userName = "simen64";
    };
  };
}
