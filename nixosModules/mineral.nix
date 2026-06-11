{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.nix-mineral.nixosModules.nix-mineral];

  options = {
    mineral = {
      enable = lib.mkEnableOption "Enable mineral module";
    };
  };

  config = lib.mkIf config.mineral.enable {
    nix-mineral = {
      enable = true;
      preset = "default";

      settings = {
        system = {
          proc-mem-force = "never";
          yama = "relaxed";
        };

        network = {
          icmp.ignore-all = false;
        };
      };

      filesystems = {
        normal = {
          # noexec on /home can be very inconvenient for desktops.
          "/home".options."noexec" = false;

          # Some applications may need to be executable in /tmp.
          "/tmp".options."noexec" = false;

          # noexec on /var(/lib) may cause breakage.
          # Because /var is noexec, set exec explicitly in order to override it
          "/var/lib" = {
            enable = true;
            options."noexec" = false;
            options."exec" = true;
          };
        };
        special."/proc".options.hidepid = lib.mkForce 0;
      };

      extras = {
        system = {
          minimize-swapping = true;
          secure-chrony = true;
          unprivileged-userns = false;
        };

        network = {
          bluetooth-kmodules = false;
        };
      };
    };

    boot.kernelParams = [
      "kvm_amd.sev=1"
      "kvm_amd.sev_es=1"
      "kvm_amd.sev_snp=1"
      "kvm-intel.vmentry_l1d_flush=always"
      "l1d_flush=on"
      "l1tf=full,force"
      "spec_store_bypass_disable=on"
      "spectre_v2=on"
      "ssbd=force-on"
      "rd.shell=0"
      "rd.emergency=halt"
      "systemd.ssh_auto=no"
      "mem_encrypt=on"
    ];
  };
}
