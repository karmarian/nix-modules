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
    userName = lib.mkOption {
      type = lib.types.str;
      default = "adbuser";
      description = "User of ADB";
    };
    adb.enable = lib.mkEnableOption "Android debugging utilities";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs = {
          kdeconnect = {
            enable = lib.mkDefault true;
            package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
          };
        };
      }

      (lib.mkIf cfg.adb.enable {

        # Android debuging tools environment
        programs.adb.enable = lib.mkDefault true;

        users.users.${cfg.userName}.extraGroups = [
          "adbusers"
          "kvm"
        ];
      })
    ]
  );
}
