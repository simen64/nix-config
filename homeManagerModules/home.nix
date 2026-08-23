{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "simen";
  home.homeDirectory = lib.mkDefault (
    if pkgs.stdenv.isDarwin
    then "/Users/simen"
    else "/home/simen"
  );

  xdg.userDirs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;

    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    templates = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";

    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/shared_projects";
    };
  };
}
