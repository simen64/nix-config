{ pkgs, lib, config, ... }: {

  options = {
    fonts = {
      enable = lib.mkEnableOption "Enable fonts module";
    };
  };

  config = lib.mkIf config.fonts.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.adwaita-mono
    ];
  };
}
