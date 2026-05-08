# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.git;

in
{
  options.mine.module.system.git = {
    enable = lib.mkEnableOption "Git apps and config";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "me@posteo.org";
      description = "Username config";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Email config";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      delta
      git-annex
      git-lfs
    ];

    programs = {
      git = {
        enable = lib.mkDefault true;
        lfs.enable = lib.mkDefault true;
      };
    };
  };
}
