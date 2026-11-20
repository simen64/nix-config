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

      signing.key =
        if pkgs.stdenv.isDarwin
        # Inline: macOS blocks other apps from reading Secretive's container, so its .pub files can't be used here
        then "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFFr3is/CNJe6Z2MHtpBAjk3nTrBnD2uMS8LK2MQMcbBM1A72Cw0+wdi+Anc/o6B3UvCdw2wB5gPd6ktQr/g5oY="
        else "~/.ssh/id_ed25519_sk_rk";
      signing.signByDefault = true;
      signing.format = "ssh";

      includes = lib.optionals pkgs.stdenv.isLinux [
        {
          condition = "gitdir:/etc/nixos/";
          path = pkgs.writeText "nixos-repo-gitconfig" ''
            [user]
              signingKey = ~/.ssh/tpm_key_signing.pub
            [core]
              sshCommand = "ssh -o IdentityAgent=$XDG_RUNTIME_DIR/ssh-tpm-agent.sock -o IdentitiesOnly=true -o IdentityFile=~/.ssh/tpm_key.pub"
          '';
        }
      ];
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
