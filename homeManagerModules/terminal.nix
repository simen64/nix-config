{ pkgs, lib, config, osConfig, ... }:

  let
    isNixOS = lib.hasAttr "nixos" osConfig.system;
    flakePath =
      if isNixOS then
        "/etc/nixos"
      else if pkgs.stdenv.isDarwin then
       "/Users/simen/nix"
      else
        "/home/simen/.config/nix-config";
  in

{
  options = {
    terminal = {
      enable = lib.mkEnableOption "Enable terminal module";
    };
  };

  config = lib.mkIf config.terminal.enable {
    programs.ghostty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
    };

    home.file = {
      ".config/ghostty/".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/ghostty";
    };

    home.packages = with pkgs; [
      direnv
      oh-my-posh
      zoxide
      fzf
    ];

    home.file = {
      ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/zshrc";
    };

  };
}
