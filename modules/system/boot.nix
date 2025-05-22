# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.boot = {
    enable = lib.mkEnableOption "Boot config";
  };

  config = lib.mkIf config.mine.module.system.boot.enable {
    # GNU/Linux kernel package.
    boot.kernelPackages = pkgs.linuxPackages_latest;
    # Bootloader configuration.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
