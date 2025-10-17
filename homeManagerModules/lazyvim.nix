{ pkgs, lib, config, ... }: {

  options = {
    lazyvim = {
        enable = lib.mkEnableOption "Enable lazyvim module";
    };
  };

  config = lib.mkIf config.lazyvim.enable {

    home.packages = with pkgs; [
      nodejs_24
      gcc
      neovim
      fzf
      wl-clipboard
      unzip
    ];

    home.file = {
      ".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/nvim;
    };
  };
}
