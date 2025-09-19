# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.container;

in
{
  options.mine.module.home.container = {
    enable = lib.mkEnableOption "Container apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dive # look into docker image layers
      flatpak
      guix
      podman
      podman-compose # start group of containers for dev
      podman-tui # status of containers in the terminal
      qemu
    ];

    programs.distrobox = {
      enable = true;
      enableSystemdUnit = true;
    };
  };
}
