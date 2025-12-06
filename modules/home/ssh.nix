# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.ssh;

in
{
  options.mine.module.home.ssh = {
    enable = lib.mkEnableOption "SSH config";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = import ./ssh/match-block.nix;
      extraConfig = import ./ssh/extra-config.nix;
    };

    services = {
      ssh-agent = {
        enable = true;
      };
    };
  };
}
