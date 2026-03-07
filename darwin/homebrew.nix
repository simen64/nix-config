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
      "postman"
      "docker-desktop"
      "podman-desktop"
      "figma"
      "copilot-cli"

      ## messaging
      "signal"
      "element"

      ## other
      "nextcloud"
      "1password"
      "obsidian"
      "spotify"
      "firefox"
      "localsend"
      "google-chrome"
      "ultimaker-cura"
      "balenaetcher"
      "blender"
      "netbirdio/tap/netbird-ui"
    ];
    brews = [
      "stow"
      "podman"
      "podman-compose"
      "docker"
      "mole"
    ];
    taps = [
    ];
  };
}
