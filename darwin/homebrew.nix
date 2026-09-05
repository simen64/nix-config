{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "raycast"
      "hyperkey"
      "rectangle"
      "aldente"

      ## dev
      "ghostty"
      "secretive"
      "copilot-cli"
      "figma"

      ## messaging
      "signal"
      "element"

      ## other
      "seafile-client"
      "seadrive"
      "1password"
      "obsidian"
      "spotify"
      "firefox"
      "prismlauncher"
      "localsend"
      "obs"
      "netbirdio/tap/netbird-ui"
      "prismlauncher"
    ];
    brews = [
      "mole"
      "colima"
      "docker"
      "docker-compose"
      "docker-buildx"
      "ffmpeg"
      {
        name = "netbirdio/tap/netbird";
        trusted = true;
      }
    ];
  };
}
