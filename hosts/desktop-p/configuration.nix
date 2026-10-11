{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop-p";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;

  services.printing.enable = true;

  home-manager.backupFileExtension = "backup";
  home-manager.users.simen.dms.enable = true;

  # nvidia drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  programs.firefox.enable = true;
  netbird.enable = true;

  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = ["gnome"];
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (final.fetchpatch {
              url = "https://github.com/Supreeeme/xwayland-satellite/commit/a8f8eeac96d7f5b6e83a49ebd7f294e9a3879f22.patch";
              hash = "sha256-LQv2DiL5vphwTzOYp+ObInQvdOf9f2F5pWRQUWm9D+E=";
            })
          ];
      });
    })
  ];

  system.stateVersion = "25.05";
}
