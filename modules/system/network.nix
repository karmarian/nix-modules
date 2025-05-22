# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.network = {
    enable = lib.mkEnableOption "Networking config";
    wireguard.enable = lib.mkEnableOption "Wireguard";
  };

  config = lib.mkIf config.mine.module.system.network.enable (
    lib.mkMerge [
      {
        programs.wireshark = {
          enable = true;
          package = pkgs.wireshark;
        };
      }

      (lib.mkIf config.mine.module.system.network.wireguard.enable {
        networking.firewall = {
          allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
        };

        # Enable WireGuard interfaces.
        networking.wireguard.interfaces = {
          # :TODO: Add optional inputs for configuring IPs, keys and other private
          # information.
          wg0 = {
            ips = [ "0.0.0.0/32" ];
            # Match firewall allowedUDPPorts (without this wg uses random port numbers).
            listenPort = 51820;
            privateKeyFile = "/etc/wireguard/wireguard.key";

            peers = [
              {
                # EU#0
                publicKey = "xxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=";
                allowedIPs = [ "0.0.0.0/0" ];
                endpoint = "0.0.0.0:51820";
                persistentKeepalive = 25;
              }
            ];
          };
        };

        environment.systemPackages = [
          pkgs.wireguard-tools
        ];
      })
    ]
  );
}
