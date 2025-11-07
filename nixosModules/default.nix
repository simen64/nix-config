{ pkgs, lib, config, ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
    ];
    dates = "12:00";
    randomizedDelaySec = "45min";
  };
}

