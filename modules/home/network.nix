# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.network = {
    enable = lib.mkEnableOption "Networking apps";
  };

  config = lib.mkIf config.mine.module.home.network.enable {
    home.packages = with pkgs; [
      netcat-gnu
      nettools
      nmap
      tcpdump
      traceroute
    ];
  };
}
