{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "raycast"
      "hyperkey"
      "rectangle"

      ## dev
      "ghostty"
      "secretive"
      "pgadmin4"

      ## messaging
      "signal"

      ## other
      "1password"
      "obsidian"
      "spotify"
      "firefox"
      "localsend"
      "google-chrome"
    ];
    brews = [
      "stow"
      "podman"
      "podman-compose"
    ];
    taps = [
    ];
  };
}
