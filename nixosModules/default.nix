{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
    ./autoUpgrade.nix
    ./onePassword.nix
    ./desktop-apps.nix
    ./niri.nix
    ../modules/nix.nix
  ];

  user.enable = lib.mkDefault true;
  autoUpgrade.enable = lib.mkDefault true;
  onePassword.enable = lib.mkDefault true;
  desktop-apps.enable = lib.mkDefault true;
  niri.enable = lib.mkDefault true;

  services.tailscale.enable = true;
}
