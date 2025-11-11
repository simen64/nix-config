{pkgs, lib, ...}: {

  imports = [
    ./dev-environment.nix
    ./fonts.nix
    ./git.nix
    #./gnome-standard-settings.nix
    #./gnome-wallpaper.nix
    # ./gnome.nix
    ./lazyvim.nix
    #./rebinds.nix
  ];

  # Enable all modules by default
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  #gnome-wallpaper.enable = lib.mkDefault true;
  #gnome-standard-settings.enable = lib.mkDefault true;
  lazyvim.enable = lib.mkDefault true;
  #rebinds.enable = lib.mkDefault true;
  #dev-environment.enable = lib.mkDefault true;
}
