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
      "netbird-ui"
      "caffeine"
    ];
    brews = [
      "mole"
      "colima"
      "docker"
      "docker-compose"
      "ffmpeg"
    ];
    taps = [
      "netbirdio/tap"
    ];
  };
}
