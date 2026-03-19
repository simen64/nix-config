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
      "copilot-cli"

      ## messaging
      "signal"
      "element"

      ## other
      "seafile-client"
      "1password"
      "obsidian"
      "spotify"
      "firefox"
      "localsend"
      "netbirdio/tap/netbird-ui"
    ];
    brews = [
      "mole"
    ];
    taps = [
    ];
  };
}
