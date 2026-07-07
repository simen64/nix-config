{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d02a6bb1-c177-4755-aa67-8346658d878f".device = "/dev/disk/by-uuid/d02a6bb1-c177-4755-aa67-8346658d878f";
  networking.hostName = "desktop-y";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager.users.simen.dms.enable = true;
  system.stateVersion = "26.05"; # Did you read the comment?
}
