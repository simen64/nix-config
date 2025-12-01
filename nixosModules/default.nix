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
    ../modules/nix.nix
  ];

  user.enable = lib.mkDefault true;
  autoUpgrade.enable = lib.mkDefault true;
  onePassword.enable = lib.mkDefault true;
}
