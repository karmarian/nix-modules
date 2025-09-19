# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ config, lib, ... }:

let
  cfg = config.mine.module.system.unfree;

in
{
  options.mine.module.system.unfree = {
    enable = lib.mkEnableOption "Allow unfree apps";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
  };
}
