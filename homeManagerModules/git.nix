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

      signing.key = "~/.ssh/id_ed25519_sk_rk-USB-C.pub";
      signing.signByDefault = true;
      signing.format = "ssh";

      includes = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        {
          condition = "gitdir:~/nix/";
          path = pkgs.writeText "nix-repo-gitconfig" ''
            [user]
              signingKey = /Users/simen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/fedda82f4d015e82453dd083b4a90cc3.pub
          '';
        }
      ];
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
