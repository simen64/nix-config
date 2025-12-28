{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc."NetworkManager/system-connections/39C3.nmconnection".text = ''
    [connection]
    id=39C3
    uuid=c80101e2-7b99-4511-846b-2388eb86a5ad
    type=wifi

    [wifi]
    mode=infrastructure
    ssid=39C3

    [wifi-security]
    auth-alg=open
    key-mgmt=wpa-eap

    [802-1x]
    altsubject-matches=DNS:radius.c3noc.net
    eap=ttls
    identity=outboundonly
    password=outboundonly
    phase2-auth=pap

    [ipv4]
    method=auto

    [ipv6]
    method=auto
  '';

  environment.etc."NetworkManager/system-connections/39C3.nmconnection".mode = "600";
}
