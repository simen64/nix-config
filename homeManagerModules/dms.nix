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
    inputs.dankMaterialShell.homeModules.dank-material-shell
    #inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  options = {
    dms = {
      enable = lib.mkEnableOption "Enable dank-niri module";
    };
  };

  config = lib.mkIf config.dms.enable {
    programs.dank-material-shell = {
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

      plugins = {
        dankBatteryAlerts.src = inputs.dms-plugins + "/DankBatteryAlerts";
        dms-display-mirror.src = inputs.dms-display-mirror;
        dms-tailscale.src = inputs.dms-tailscale;
      };
    };

    home.file = {
      ".config/niri/".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/niri";
      ".config/DankMaterialShell/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/DankMaterialShell/settings.json";
      ".config/DankMaterialShell/plugin_settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/DankMaterialShell/plugin_settings.json";
    };
  };
}
