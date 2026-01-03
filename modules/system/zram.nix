# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.zram;

in
{
  options.mine.module.system.zram = {
    enable = lib.mkEnableOption "Zram";
  };

  config = lib.mkIf cfg.enable {
    zramSwap.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      gtop
    ];
  };
}
