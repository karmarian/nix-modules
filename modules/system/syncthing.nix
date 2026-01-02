# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.syncthing;

in
{
  options.mine.module.system.syncthing = {
    firewall.open = lib.mkEnableOption "Syncthing firewall rules";
  };

  config = lib.mkIf cfg.firewall.open {
    # Open ports in the firewall.
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall.allowedTCPPorts = lib.mkDefault [
      8384
      22000
    ];
    networking.firewall.allowedUDPPorts = lib.mkDefault [
      22000
      21027
    ];
  };
}
