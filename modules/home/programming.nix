# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.programming = {
    enable = lib.mkEnableOption "Programming apps";
  };

  config = lib.mkIf config.mine.module.home.programming.enable {
    home.packages = with pkgs; [
      cachix
      cntr
      mob
      nix-diff
      nix-output-monitor
      nix-top
      npins
      nvd
      stow
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
