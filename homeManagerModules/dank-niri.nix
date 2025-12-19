{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
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
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    #inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  options = {
    dank-niri = {
      enable = lib.mkEnableOption "Enable dank-niri module";
    };
  };

  config = lib.mkIf config.dank-niri.enable {
    programs.dankMaterialShell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
    };

    home.file = {
      ".config/niri/".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/niri";
      ".config/DankMaterialShell".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/DankMaterialShell";
    };
  };
}
