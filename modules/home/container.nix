# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.container = {
    enable = lib.mkEnableOption "Container apps";
  };

  config = lib.mkIf config.mine.module.home.container.enable {
    home.packages = with pkgs; [
      dive # look into docker image layers
      distrobox
      flatpak
      guix
      podman
      podman-compose # start group of containers for dev
      podman-tui # status of containers in the terminal
      qemu
    ];
  };
}
