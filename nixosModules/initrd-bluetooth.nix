{
  lib,
  config,
  pkgs,
  ...
}: let
  bluez = config.hardware.bluetooth.package;
in {
  options = {
    initrd-bluetooth = {
      enable = lib.mkEnableOption "Bluetooth keyboards in stage 1 (for typing the LUKS password)";
    };
  };

  config = lib.mkIf config.initrd-bluetooth.enable {
    hardware.bluetooth.enable = true;

    boot.initrd = {
      systemd.enable = true;

      kernelModules = ["btusb" "uhid"];
      availableKernelModules = ["bluetooth" "btrtl" "btintel" "btbcm" "btmtk" "hid_generic" "hid_logitech_hidpp"];

      # Pairing keys of the running system. Appended to the initrd on the ESP
      # (unencrypted) when the bootloader is installed, so re-pairing a device
      # requires a rebuild before it works at the LUKS prompt.
      secrets."/var/lib/bluetooth" = "/var/lib/bluetooth";

      systemd = {
        dbus.enable = true;
        # Same as the dbus module's config, plus bluez's policy so bluetoothd may own org.bluez
        contents."/etc/dbus-1".source = lib.mkForce (pkgs.makeDBusConf.override {
          inherit (config.services.dbus) apparmor;
          dbus = config.services.dbus.dbusPackage;
          suidHelper = "/bin/false";
          serviceDirectories = [
            config.services.dbus.dbusPackage
            config.boot.initrd.systemd.package
            bluez
          ];
        });
        contents."/etc/bluetooth/main.conf".source = config.environment.etc."bluetooth/main.conf".source;
        contents."/etc/bluetooth/input.conf".source = config.environment.etc."bluetooth/input.conf".source;

        storePaths = [
          "${bluez}/libexec/bluetooth/bluetoothd"
          "${bluez}/share/dbus-1/system.d"
        ];

        services.bluetooth = {
          description = "Bluetooth service (initrd)";
          wantedBy = ["sysinit.target"];
          requires = ["dbus.socket"];
          after = ["dbus.socket" "initrd-nixos-copy-secrets.service"];
          before = ["cryptsetup-pre.target" "initrd-switch-root.target" "shutdown.target"];
          conflicts = ["initrd-switch-root.target" "shutdown.target"];
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "dbus";
            BusName = "org.bluez";
            ExecStart = "${bluez}/libexec/bluetooth/bluetoothd";
          };
        };
      };
    };
  };
}
