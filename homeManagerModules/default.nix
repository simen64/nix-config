{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./terminal.nix
    ./podman.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./lazyvim.nix
    ./rebinds.nix
    ./ssh.nix
  ];

  # Enable all modules by default
  terminal.enable = lib.mkDefault true;
  podman.enable = lib.mkDefault false;
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  gnome.enable = lib.mkDefault true;
  lazyvim.enable = lib.mkDefault true;
  rebinds.enable = lib.mkDefault true;
  ssh.enable = lib.mkDefault true;

  home.packages = with pkgs; [
    alejandra
  ];
}
