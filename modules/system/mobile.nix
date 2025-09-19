# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.mobile;

in
{
  options.mine.module.system.mobile = {
    enable = lib.mkEnableOption "Smartphone utilities";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };

      # Android debuging tools environment
      adb.enable = true;
    };
  };
}
