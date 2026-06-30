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
    home.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-tpm-agent.sock";
    };

    programs.git = {
      enable = true;
      settings = {
        user.email = "simenmunch@gmail.com";
        user.name = "simen64";
      };

      signing.key = "~/.ssh/id_ed25519_sk_rk";
      signing.signByDefault = true;
      signing.format = "ssh";

      includes =
        (lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          {
            condition = "gitdir:~/nix/";
            path = pkgs.writeText "nix-repo-gitconfig" ''
              [user]
                signingKey = /Users/simen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/fedda82f4d015e82453dd083b4a90cc3.pub
            '';
          }
        ])
        ++ (lib.optionals pkgs.stdenv.isLinux [
          {
            condition = "gitdir:/etc/nixos/";
            path = pkgs.writeText "nixos-repo-gitconfig" ''
              [user]
                signingKey = ~/.ssh/tpm_key_signing.pub
              [core]
                sshCommand = "ssh -o IdentityAgent=$XDG_RUNTIME_DIR/ssh-tpm-agent.sock -o IdentitiesOnly=true -o IdentityFile=~/.ssh/tpm_key.pub"
            '';
          }
        ]);
    };

    services = {
      ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
      ssh-agent = lib.mkIf pkgs.stdenv.isLinux {
        enable = false;
      };
    };
  };
}
