{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    user = {
      enable = lib.mkEnableOption "Enable user module";
    };
  };

  config = lib.mkIf config.user.enable {
    users.users.simen = {
      isNormalUser = true;
      description = "Simen";
      extraGroups = ["networkmanager" "wheel" "tss" "dialout" "tty"];
      shell = pkgs.zsh;
      packages = with pkgs; [
        #  thunderbird
      ];
    };
  };
}
