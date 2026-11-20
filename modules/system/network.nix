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
    wireguard = {
      enable = lib.mkEnableOption "Wireguard";
      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the WireGuard private key file";
      };
    };
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
          gui.enable = lib.mkDefault true;
        };
      })

      (lib.mkIf cfg.protonvpn.enable {
        environment.systemPackages = with pkgs; [
          proton-vpn
        ];
      })

      (lib.mkIf (cfg.wireguard.enable && cfg.wireguard.keyFile != null) {
        networking.firewall.allowedUDPPorts = lib.mkDefault [ 51820 ];

        networking.wireguard.interfaces.wg0 = {
          ips = [ "0.0.0.0/32" ]; # replace with real address when wiring up
          listenPort = 51820;
          privateKeyFile = toString cfg.wireguard.keyFile;
          peers = [
            # fill in when wiring up
          ];
        };

        environment.systemPackages = [ pkgs.wireguard-tools ];
      })
    ]
  );
}
