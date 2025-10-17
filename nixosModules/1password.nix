{ pkgs, lib, config, ... }: {
  options = {
    1password = {
      enable = lib.mkEnableOption "Enable 1Password programs and GUI integration.";
      polkitOwner = lib.mkOption {
        type = lib.types.str;
        default = "simen";
        description = "Username to own 1Password PolKit policy integration.";
      };
    };
  };

  config = lib.mkIf config.1password.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.1password.polkitOwner ];
    };
  };
}

