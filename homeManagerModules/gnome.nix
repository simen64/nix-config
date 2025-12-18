{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./gnome-wallpaper.nix
    ./gnome-standard-settings.nix
  ];

  options = {
    gnome = {
      enable = lib.mkEnableOption "Enable GNOME configuration";
    };
  };

  config = lib.mkIf config.gnome.enable {
    gnome-wallpaper.enable = lib.mkDefault true;
    gnome-standard-settings.enable = lib.mkDefault true;

    home.activation.linkDesktopFiles = lib.hm.dag.entryAfter ["installPackages"] ''
      if [ -d "${config.home.profileDirectory}/share/applications" ]; then
        rm -rf ${config.home.homeDirectory}/.local/share/applications
        mkdir -p ${config.home.homeDirectory}/.local/share/applications
        for file in ${config.home.profileDirectory}/share/applications/*; do
          ln -sf "$file" ${config.home.homeDirectory}/.local/share/applications/
        done
      fi
    '';
  };
}
