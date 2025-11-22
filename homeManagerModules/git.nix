{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    git = {
      enable = lib.mkEnableOption "Enable git module";
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.email = "simenmunch@gmail.com";
        user.name = "simen64";
      };

      signing.key = "/Users/simen/.ssh/id_ed25519_sk_rk-USB-C.pub";
      signing.signByDefault = true;
      signing.format = "ssh";
    };

    services = {
      ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
      ssh-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
    };
  };
}
