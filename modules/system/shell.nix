# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.shell = {
    enable = lib.mkEnableOption "Shell utilities";
  };

  config = lib.mkIf config.mine.module.system.shell.enable {
    environment.systemPackages = with pkgs; [
      gparted
      vim
      wget
    ];

    programs = {
      screen = {
        enable = true;
        screenrc = "
          truecolor on
        ";
      };
      mtr.enable = true;
    };
  };
}
