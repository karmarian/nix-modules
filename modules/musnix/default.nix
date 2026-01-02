# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.musnix = {
    enable = lib.mkEnableOption "Musnix config";
  };

  config = lib.mkIf config.mine.module.musnix.enable {
    musnix = {
      enable = true;
      rtcqs.enable = lib.mkDefault true;
      rtirq.enable = lib.mkDefault true;
      kernel = {
        realtime = lib.mkDefault true;
        packages = pkgs.linuxPackages_latest_rt;
      };
    };
  };
}
