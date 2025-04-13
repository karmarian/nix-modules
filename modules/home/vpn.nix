# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.vpn = {
    enable = lib.mkEnableOption "VPN apps";
  };

  config = lib.mkIf config.mine.module.home.vpn.enable {
    home.packages = with pkgs; [
      protonvpn-gui
    ];
  };
}
