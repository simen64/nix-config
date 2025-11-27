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
    terminal = {
      enable = lib.mkEnableOption "Enable terminal module";
    };
  };

  config = lib.mkIf config.terminal.enable {
    programs.ghostty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = "AdwaitaMono Nerd Font";
        font-size = 14;
        window-padding-x = 10;
        window-padding-y = 10;
        theme = "Everforest Dark - Hard";
        keybind = "ctrl+t=new_tab";
      };
      themes = {
        everforest-dark = {
          background = "2D353B";
          foreground = "D3C6AA";
          cursor-color = "E69875";
          selection-background = "543A48";
          selection-foreground = "D3C6AA";
          palette = [
            "0=#232A2E"
            "1=#E67E80"
            "2=#A7C080"
            "3=#DBBC7F"
            "4=#7FBBB3"
            "5=#D699B6"
            "6=#83C092"
            "7=#4F585E"
            "8=#3D484D"
            "9=#543A48"
            "10=#425047"
            "11=#4D4C43"
            "12=#3A515D"
            "13=#514045"
            "14=#83C092"
            "15=#D3C6AA"
          ];
        };
      };
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
