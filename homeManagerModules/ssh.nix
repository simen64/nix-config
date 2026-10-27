{
  pkgs,
  lib,
  config,
  ...
}: let
  secretiveAgent = "/Users/simen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  secretivePubKeys = "/Users/simen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys";
  yubikeys = [
    "~/.ssh/id_ed25519_sk_rk-USB-C"
    "~/.ssh/id_ed25519_sk_rk"
  ];
  # Homelab: YubiKey only, never the Secretive agent
  yubikeyOnly = {
    IdentityAgent = "none";
    IdentitiesOnly = true;
    IdentityFile = yubikeys;
  };
in {
  options = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh module";
    };
  };

  config = lib.mkIf config.ssh.enable {
    home.packages = with pkgs; [
      openssh
    ];

    home.file.".ssh/secretive_github.pub" = lib.mkIf pkgs.stdenv.isDarwin {
      text = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPRmlZbDw1Owbg2X4fxlb34VMExi/kx6T4txnJGq1MECBp96vB76qhHuEPpj3/iy7gCgIHm/6fcflRKpT6cgcNE= github@secretive\n";
    };

    programs.ssh = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      enableDefaultConfig = false;
      includes = ["/Users/simen/.colima/ssh_config"];

      settings = {
        # --- Homelab (YubiKey) ---
        # Remote alias used by nix-homelab: git@github:simen64/nix-homelab.git
        github =
          yubikeyOnly
          // {
            HostName = "github.com";
            User = "git";
          };
        "forgejo.simenmo.com" = yubikeyOnly;
        "192.168.50.*" = yubikeyOnly;
        "172.31.0.*" = yubikeyOnly;
        "192.168.50.3" = {
          KexAlgorithms = "diffie-hellman-group-exchange-sha1";
          HostKeyAlgorithms = "+ssh-rsa";
        };

        # --- Secretive ---
        "github.com" = {
          IdentitiesOnly = true;
          IdentityFile = "~/.ssh/secretive_github.pub";
        };
        github-nix = {
          HostName = "github.com";
          IdentitiesOnly = true;
          IdentityFile = "${secretivePubKeys}/eaae56d2662da0f16eac5f350789bc03.pub";
        };
        github-noteapp = {
          HostName = "github.com";
          IdentitiesOnly = true;
          IdentityFile = "${secretivePubKeys}/4d40ef461bc137ac80987045f8e8018c.pub";
        };

        # Default: Secretive agent for everything else
        "*" = {
          IdentityAgent = secretiveAgent;
          PubkeyAuthentication = true;
          SetEnv.TERM = "xterm-256color";
          ServerAliveInterval = 10;
        };
      };
    };
  };
}
