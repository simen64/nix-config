{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
      # brew bundle upgrades and zaps silently after the last "Using ..." line,
      # which looks like a hang. Show what it is doing.
      extraFlags = ["--verbose"];
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
      "figma"

      ## messaging

      ## other
      "seafile-client"
      "seadrive"
      "1password"
      "blender"
      "obsidian"
      "spotify"
      "firefox"
      "prismlauncher"
      "localsend"
      "obs"
      "netbirdio/tap/netbird-ui"
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
