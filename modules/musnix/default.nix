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
        # Rebuilds the Linux kernel.
        realtime = lib.mkDefault false;
        packages = pkgs.linuxPackages_latest_rt;
      };
    };
  };
}
