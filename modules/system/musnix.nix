# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ config, lib, ... }:

{
  options.mine.module.system.musnix = {
    enable = lib.mkEnableOption "Musnix config";
  };

  config = lib.mkIf config.mine.module.system.musnix.enable {
    musnix = {
      enable = true;
      rtcqs.enable = true;
      kernel.realtime = false;
    };
  };
}
