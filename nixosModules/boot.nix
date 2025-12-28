{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.limine;
in
{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  options.profiles.limine.enable = lib.mkEnableOption "Limine bootloader";
  options.profiles.limine.secureboot = lib.mkEnableOption "Secureboot";

  config = lib.mkIf cfg.enable {
    boot.loader = {
      limine = {
        enable = true;
        maxGenerations = 5;
        secureBoot.enable = cfg.secureboot;
        style = {
          interface = {
            branding = "if found, please return to Simen Munch-Olsen - +47 41317327";
            resolution = "1920x1200";
          };
          graphicalTerminal = {
            palette = "4c4f69;d20f39;40a02b;dc8a78;1e66f5;ea76cb;209fb5;7c7f93";
            font.scale = "3x3";
          };
          wallpapers = [
            ../wallpapers/forest.jpg
          ];
        };
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
