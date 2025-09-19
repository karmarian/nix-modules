# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.shell;

in
{
  options.mine.module.system.shell = {
    enable = lib.mkEnableOption "Shell utilities";
  };

  config = lib.mkIf cfg.enable {
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
