{
  lib,
  config,
  ...
}: {
  options = {
    run0 = {
      enable = lib.mkEnableOption "Enable run0 module";
    };
  };

  config = lib.mkIf config.run0.enable {
    users.users.admin = {
      isNormalUser = true;
      description = "System administrator";
      extraGroups = ["wheel" "libvirtd"]; # wheel = sudo, libvirtd for VMs
      # run `mkpasswd --method=yescrypt` and replace "changeme" w/ the result
      initialHashedPassword = "$y$j9T$A7R0bbU8kryhY/JVZFT2/0$2dHyW/naXQwBqs3gnQcDMikuus0FUuiHYtsWCu36cl5"; # change with `passwd admin` later
    };
    users.users.simen = {
      isNormalUser = lib.mkForce true;
      description = lib.mkForce "Simen";
      extraGroups = lib.mkForce ["networkmanager" "audio" "video" "tty" "tss" "dialout" "nix-users" "greeter"];
    };

    users.groups.nix-users = {};
    nix.settings.allowed-users = [
      "@wheel"
      "@nix-users"
    ];

    security.polkit.enable = true;
    security.sudo.enable = lib.mkForce false;
  };
}
