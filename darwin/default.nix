{ pkgs, inputs, self, ... }: {

  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # disabled due to https://github.com/NixOS/nix/issues/7273
      # auto-optimise-store = true;
    };
    enable = false; # using determinate installer
  };

  nixpkgs.config.allowUnfree = true;

  nix-homebrew = {
    user = "simen";
    enable = true;
    autoMigrate = true;
  };

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.simen = {
      imports = [
        ../homeManagerModules
      ];

      gnome.enable = false;

      home.stateVersion = "25.05";

    };
    extraSpecialArgs = {
      inherit inputs self;
    };
  };

  # macOS-specific settings
  system.primaryUser = "simen";
  users.users.simen = {
    home = "/Users/simen";
    shell = pkgs.zsh;
  };
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
}
