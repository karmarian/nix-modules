# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.boot;

in
{
  options.mine.module.system.boot = {
    enable = lib.mkEnableOption "Boot config";
  };

  config = lib.mkIf cfg.enable {
    # GNU/Linux kernel package.
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    # Bootloader configuration.
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
