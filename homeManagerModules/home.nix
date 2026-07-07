{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "simen";
  home.homeDirectory = "/home/simen";

  xdg.userDirs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    templates = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";

    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/shared_projects";
    };
  };
}
