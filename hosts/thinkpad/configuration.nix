{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  networking.hostName = "simens-laptop";

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  services.gnome.games.enable = false;
  programs.dconf.enable = true;

  services.xserver.xkb.variant = "winkeys";
  services.printing.enable = false;

  programs.localsend.enable = true;

  services.fwupd.enable = true;

  netbird.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-fonts
    adwaita-icon-theme
    sbctl
    github-copilot-cli
  ];

  # Fingerprint reader
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  profiles = {
    limine = {
      enable = true;
      secureboot = false;
    };
  };

  services = {
    fprintd.enable = true;
    envfs.enable = true;
    pcscd.enable = true;
  };

  security.pam.services = {
    login.unixAuth = true;
    login.fprintAuth = false;
    sddm.fprintAuth = false;
    xscreensaver.fprintAuth = true;
  };

  hardening.enable = true;
  hardening.hardened_malloc.enable = false;
  run0.enable = true;

  system.stateVersion = "25.05";
}
