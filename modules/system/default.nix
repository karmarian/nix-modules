# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./jellyfin.nix
    ./mobile.nix
    # ./musnix.nix
    ./nix.nix
    ./pipewire.nix
    ./printing.nix
    ./remote-desktop.nix
    ./shell.nix
    ./store-optimization.nix
    ./syncthing.nix
    ./unfree.nix
    ./virtualisation.nix
    ./wireguard.nix
    ./zram.nix
  ];

  options.mine.module.system.all = {
    enable = lib.mkEnableOption "All system apps";
  };

  config = lib.mkIf config.mine.module.system.all.enable {
    mine.module.system = {
      boot.enable = true;
      gnome.enable = true;
      jellyfin.enable = true;
      mobile.enable = true;
      # :TODO: Enable Musnix at least with the Flake build again.
      # musnix.enable = true;
      nix.enable = true;
      pipewire.enable = true;
      printing.enable = true;
      remote-desktop.enable = true;
      shell.enable = true;
      store-optimization.enable = true;
      syncthing.enable = true;
      unfree.enable = true;
      virtualisation.enable = true;
      wireguard.enable = true;
      zram.enable = true;
    };
  };
}
