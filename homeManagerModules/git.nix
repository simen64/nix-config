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

      signing.key = 
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Users/simen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/fedda82f4d015e82453dd083b4a90cc3.pub"
        else if pkgs.stdenv.hostPlatform.isLinux then
          "your-linux-gpg-key-id"
        else
          "default-gpg-key-id";

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

  }
);
}
