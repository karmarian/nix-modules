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
    ./sway.nix
    ./syncthing.nix
    ./unfree.nix
    ./virtualisation.nix
    ./zram.nix
  ];

  options.mine.module.system.default = {
    scheme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Enable supported scheme like 'all', 'gnome', 'sway' or 'headless'";
    };
  };

  config.mine.module.system = lib.mkMerge [
    (lib.mkIf (config.mine.module.system.default.scheme == "all") {
      audiobookshelf = {
        enable = true;
      };
      boot.enable = true;
      gnome = {
        enable = true;
        autoLogin.enable = true;
      };
      immich = {
        enable = true;
      };
      jellyfin = {
        enable = true;
      };
      locale = {
        enable = true;
      };
      mobile.enable = true;
      network = {
        enable = true;
        mullvad-vpn.enable = true;
        protonvpn.enable = true;
        # VPN profile is not generic and correct settings have to applied.
        wireguard.enable = false;
      };
      nix = {
        enable = true;
        store-optimisation.enable = true;
        auto-upgrade.enable = true;
      };
      pipewire.enable = true;
      printing.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      sway.enable = false;
      syncthing.firewall.open = true;
      unfree.enable = true;
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
        variant.enable = true;
        waydroid.enable = true;
        waydroid.autostart = true;
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "gnome") {
      boot.enable = true;
      gnome = {
        enable = true;
        autoLogin.enable = true;
      };
      locale = {
        enable = true;
      };
      mobile.enable = true;
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        store-optimisation.enable = true;
        auto-upgrade.enable = true;
      };
      pipewire.enable = true;
      printing.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      syncthing.firewall.open = true;
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
        variant.enable = true;
        waydroid.enable = true;
        waydroid.autostart = true;
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "sway") {
      boot.enable = true;
      locale = {
        enable = true;
      };
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        store-optimisation.enable = true;
        auto-upgrade.enable = true;
      };
      pipewire.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      sway.enable = true;
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "headless") {
      audiobookshelf = {
        enable = true;
      };
      boot.enable = true;
      immich = {
        enable = true;
      };
      jellyfin = {
        enable = true;
      };
      locale = {
        enable = true;
      };
      network = {
        enable = true;
      };
      nix = {
        enable = true;
        store-optimisation.enable = true;
        auto-upgrade.enable = true;
      };
      pipewire.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      syncthing.firewall.open = true;
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
        variant.enable = true;
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "music") {
      boot.enable = true;
      gnome = {
        enable = true;
        autoLogin.enable = false;
      };
      locale = {
        enable = true;
      };
      nix = {
        enable = true;
      };
      pipewire.enable = true;
    })
  ];
}
