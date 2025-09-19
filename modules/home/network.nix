# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.network;

in
{
  options.mine.module.home.network = {
    enable = lib.mkEnableOption "Networking apps";
    vpn.enable = lib.mkEnableOption "Virtual Private Networking apps";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          netcat-gnu
          netop
          nettools
          nmap
          tcpdump
          traceroute
          transmission_4-gtk
        ];
      }

      (lib.mkIf cfg.vpn.enable {
        home.packages = with pkgs; [
          protonvpn-gui
        ];
      })
    ]
  );
}
