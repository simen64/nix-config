{ pkgs, ... }: {

  networking.hostName = "simens-macbook";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # host-specific homebrew casks
  homebrew.casks = [
    # "slack"
  ];
  # host-specific home-manager configuration
  home-manager.users.simen = {
    home.packages = with pkgs; [
    ];

    programs = {
    };
  };
}
