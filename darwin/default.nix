{
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./homebrew.nix
    ./settings.nix
    ../modules/nix.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

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
      rebinds.enable = false;
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
    pathsToLink = ["/Applications"];
  };
}
