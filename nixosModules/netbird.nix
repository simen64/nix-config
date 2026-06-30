{
  lib,
  config,
  ...
}: {
  options = {
    netbird = {
      enable = lib.mkEnableOption "Enable Netbird client integration.";

      name = lib.mkOption {
        type = lib.types.str;
        default = "netbird";
        description = "Netbird client name.";
      };
    };
  };

  config = lib.mkIf config.netbird.enable {
    services.netbird.enable = true;

    users.users.netbird = {
      isSystemUser = true;
      group = "netbird";
    };
    users.groups.netbird = {};

    services.netbird.clients.default = {
      environment.NB_MANAGEMENT_URL = "http://vpn.simenmo.com:80";
      port = 51820;
      name = config.netbird.name;
      interface = "wt0";
      hardened = false;
    };
  };
}
