# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ config, lib, ... }:

{
  options.mine.module.system.unfree = {
    enable = lib.mkEnableOption "Allow unfree apps";
  };

  config = lib.mkIf config.mine.module.system.unfree.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
  };
}
