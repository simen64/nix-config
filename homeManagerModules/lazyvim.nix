{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  flakePath =
    if isNixOS
    then "/etc/nixos"
    else if pkgs.stdenv.isDarwin
    then "/Users/simen/nix"
    else "/home/simen/.config/nix-config";
in {
  options = {
    lazyvim = {
      enable = lib.mkEnableOption "Enable lazyvim module";
    };
  };

  config = lib.mkIf config.lazyvim.enable {
    home.packages = with pkgs; [
      nodejs_24
      gcc
      neovim
      fzf
      unzip
      ripgrep
      qwen-code
      lazygit
    ] ++ lib.optional pkgs.stdenv.isLinux wl-clipboard;

    home.file = {
      ".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
    };
  };
}
