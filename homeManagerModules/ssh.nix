{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh module";
    };
  };

  config = lib.mkIf config.ssh.enable {
    home.packages = with pkgs; [
      openssh
    ];

    programs.ssh.extraConfig = ''
      PubkeyAuthentication yes
      IdentityAgent none
      IdentitiesOnly true
      IdentityFile $HOME/.ssh/id_ed25519_sk_rk
    '';
  };
}
