{
  description = "Nixos config flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

  };

  outputs = { self, nixpkgs, ... } @inputs: {
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/thinkpad/configuration.nix
        inputs.home-manager.nixosModules.default
      	inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}
