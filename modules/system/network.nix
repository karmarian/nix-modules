# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.network;

  mullvad-autostart = pkgs.makeAutostartItem {
    name = "mullvad-vpn";
    package = pkgs.mullvad-vpn;
  };

in
{
  options.mine.module.system.network = {
    enable = lib.mkEnableOption "Networking config";
    mullvad-vpn.enable = lib.mkEnableOption "Mullvad Virtual Private Networking app";
    protonvpn.enable = lib.mkEnableOption "Proton Virtual Private Networking app";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "wireshark";
      description = "User of Wireshark";
    };
    wireguard.enable = lib.mkEnableOption "Wireguard";
    wireshark.enable = lib.mkEnableOption "Wireshark";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          netcat-gnu
          netop
          nettools
          nmap
          tcpdump
          traceroute
          transmission_4-gtk
        ];
      }
      (lib.mkIf cfg.wireshark.enable {
        environment.systemPackages = with pkgs; [
          wireshark
        ];

        users.users.${cfg.userName}.extraGroups = [ "wireshark" ];
      })

      (lib.mkIf cfg.mullvad-vpn.enable {
        environment.systemPackages = [ mullvad-autostart ];

        services.mullvad-vpn = {
          enable = lib.mkDefault true;
          package = lib.mkDefault pkgs.mullvad-vpn;
        };
      })

      (lib.mkIf cfg.protonvpn.enable {
        environment.systemPackages = with pkgs; [
          protonvpn-gui
        ];
      })

      (lib.mkIf cfg.wireguard.enable {
        networking.firewall = {
          allowedUDPPorts = lib.mkDefault [ 51820 ]; # Clients and peers can use the same port, see listenport
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
