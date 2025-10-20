{pkgs, lib, ...}: {
  imports = [
    ./fonts.nix
    ./git.nix
  ];

  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
}
