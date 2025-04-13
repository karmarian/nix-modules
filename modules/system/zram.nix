# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.zram = {
    enable = lib.mkEnableOption "Zram";
  };

  config = lib.mkIf config.mine.module.system.zram.enable {
    zramSwap.enable = true;

    environment.systemPackages = with pkgs; [
      gtop
    ];
  };
}
