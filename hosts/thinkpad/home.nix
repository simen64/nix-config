{ config, pkgs, lib, ... }:

{
  imports = [
    ../../nixosModules/gnome.nix
    ../../nixosModules/terminal.nix
    ../../homeManagerModules/rebinds.nix
    ../../homeManagerModules/lazyvim.nix
  ];

  rebinds.enable = true;
  lazyvim.enable = true;

  home.username = "simen";
  home.homeDirectory = "/home/simen";
  
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nmap
    pkgs.rpi-imager    
    pkgs.zoxide
    pkgs.dconf-editor
    gnomeExtensions.blur-my-shell
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    # ".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/nvim;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/simen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    enable = true;
    userEmail = "joe@example.org";
    userName = "joe";
  };


  # gnome applications temp fix
  home.activation.linkDesktopFiles = lib.hm.dag.entryAfter ["installPackages"] ''
    if [ -d "${config.home.profileDirectory}/share/applications" ]; then
      rm -rf ${config.home.homeDirectory}/.local/share/applications
      mkdir -p ${config.home.homeDirectory}/.local/share/applications
      for file in ${config.home.profileDirectory}/share/applications/*; do
        ln -sf "$file" ${config.home.homeDirectory}/.local/share/applications/
      done
    fi
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
