{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
    ./autoUpgrade.nix
    ./onePassword.nix
    ./desktop-apps.nix
    ./niri.nix
    ./netbird.nix
    ../modules/nix.nix
    ./boot.nix
    ./hardening.nix
    ./run0.nix
  ];

  user.enable = lib.mkDefault true;
  autoUpgrade.enable = lib.mkDefault true;
  onePassword.enable = lib.mkDefault true;
  desktop-apps.enable = lib.mkDefault true;
  niri.enable = lib.mkDefault true;
  netbird.enable = lib.mkDefault true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  networking.networkmanager.enable = lib.mkDefault true;
  time.timeZone = lib.mkDefault "Europe/Oslo";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  services.xserver.xkb.layout = lib.mkDefault "no";
  console.keyMap = lib.mkDefault "no";

  services.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  security.tpm2.enable = lib.mkDefault true;
  security.tpm2.applyUdevRules = lib.mkDefault true;
  security.tpm2.tctiEnvironment.enable = lib.mkDefault true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.simen.imports = [../homeManagerModules];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;
  programs.nix-ld.enable = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
}
