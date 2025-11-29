# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./audiobookshelf.nix
    ./boot.nix
    ./gnome.nix
    ./immich.nix
    ./jellyfin.nix
    ./locale.nix
    ./mobile.nix
    ./network.nix
    ./nix.nix
    ./pipewire.nix
    ./printing.nix
    ./remote-desktop.nix
    ./shell.nix
    ./syncthing.nix
    ./unfree.nix
    ./virtualisation.nix
    ./zram.nix
  ];

  options.mine.module.system.all = {
    enable = lib.mkEnableOption "All basic system modules";
  };

  config = lib.mkIf config.mine.module.system.all.enable {
    mine.module.system = {
      audiobookshelf.enable = true;
      boot.enable = true;
      gnome.enable = true;
      immich.enable = true;
      jellyfin.enable = true;
      locale.enable = true;
      mobile.enable = true;
      network.enable = true;
      nix.enable = true;
      pipewire.enable = true;
      printing.enable = true;
      remote-desktop.enable = true;
      shell.enable = true;
      syncthing.firewall.open = true;
      unfree.enable = true;
      virtualisation.enable = true;
      zram.enable = true;
    };
  };
}
