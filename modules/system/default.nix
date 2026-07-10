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
    ./desktop.nix
    ./emacs.nix
    ./git.nix
    ./gnome.nix
    ./immich.nix
    ./jellyfin.nix
    ./locale.nix
    ./media.nix
    ./mobile.nix
    ./music.nix
    ./network.nix
    ./nix.nix
    ./pipewire.nix
    ./printing.nix
    ./programming.nix
    ./remote-desktop.nix
    ./shell.nix
    ./ssh.nix
    ./sway.nix
    ./syncthing.nix
    ./tex.nix
    ./unfree.nix
    ./vim.nix
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
      desktop = {
        enable = true;
        browser.enable = true;
        browser.privacy.enable = true;
        utils.enable = true;
      };
      emacs = {
        enable = true;
        comms = true;
        core = true;
        dev = true;
        evil = true;
        music = true;
        org = true;
        package = true;
        shell = true;
      };
      git = {
        enable = true;
      };
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
      media = {
        enable = true;
        mpd.enable = true;
        gstreamer.enable = true;
      };
      mobile = {
        enable = true;
        android.enable = true;
      };
      music.enable = true;
      network = {
        enable = true;
        mullvad-vpn.enable = true;
        protonvpn.enable = true;
        # VPN profile is not generic and correct settings have to applied.
        wireguard.enable = false;
        wireshark.enable = true;
      };
      nix = {
        enable = true;
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      printing.enable = true;
      programming = {
        enable = true;
        python.enable = true;
      };
      remote-desktop = {
        enable = true;
        rdp.enable = false;
        weylus.enable = true;
      };
      shell = {
        enable = true;
        autoLogin.enable = true;
        bash.enable = true;
        ollama.enable = true;
        ollama.autostart = true;
      };
      ssh = {
        enable = true;
        client = {
          enable = true;
        };

        server = {
          enable = true;
          ports = [ 22 ];
          permitRootLogin = "no";
          passwordAuthentication = false;
        };
      };
      sway.enable = false;
      syncthing = {
        enable = true;
        pregeneratedFiles = false;
      };
      tex.enable = true;
      unfree.enable = true;
      vim.enable = true;
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
        packageManager.flatpak.enable = true;
        packageManager.guix.enable = true;
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
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      printing.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
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
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
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
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      ssh = {
        enable = true;
        server = {
          enable = true;
          ports = [ 22 ];
          permitRootLogin = "no";
          passwordAuthentication = false;
        };
      };
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "workstation") {
      boot.enable = true;
      desktop = {
        enable = true;
        browser.privacy.enable = true;
      };
      emacs = {
        enable = true;
        comms = true;
        core = true;
        dev = true;
        evil = true;
        music = true;
        org = true;
        shell = true;
      };
      git = {
        enable = true;
      };
      gnome = {
        enable = true;
      };
      locale = {
        enable = true;
      };
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      printing.enable = true;
      programming = {
        enable = true;
      };
      shell = {
        enable = true;
        bash.enable = true;
      };
      ssh = {
        enable = true;
        client = {
          enable = true;
        };
      };
      vim.enable = true;
      virtualisation = {
        enable = true;
        binfmt.enable = true;
        container.enable = true;
        packageManager.flatpak.enable = true;
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "music") {
      boot.enable = true;
      locale = {
        enable = true;
      };
      media = {
        enable = true;
      };
      music.enable = true;
      nix = {
        enable = true;
        lix.enable = true;
      };
      pipewire.enable = true;
      sway.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "mediaserver") {
      audiobookshelf = {
        enable = true;
      };
      boot.enable = true;
      desktop = {
        enable = true;
        browser.enable = true;
      };
      git = {
        enable = true;
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
      media = {
        enable = true;
        mpd.enable = true;
        plasma-bigscreen.enable = true;
      };
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      shell = {
        enable = true;
        autoLogin.enable = true;
      };
      ssh = {
        enable = true;
        server = {
          enable = true;
        };
      };
      zram.enable = true;
    })
    (lib.mkIf (config.mine.module.system.default.scheme == "phone") {
      boot.enable = true;
      gnome = {
        enable = true;
      };
      locale = {
        enable = true;
      };
      mobile = {
        enable = true;
      };
      network = {
        enable = true;
        mullvad-vpn.enable = true;
      };
      nix = {
        enable = true;
        lix.enable = true;
        store-optimisation.enable = true;
        auto-upgrade = {
          enable = true;
          method = "flake";
        };
      };
      pipewire.enable = true;
      shell = {
        enable = true;
      };
      ssh = {
        enable = true;
        server = {
          enable = true;
        };
      };
      virtualisation = {
        enable = true;
        packageManager.flatpak.enable = true;
        waydroid.enable = true;
        waydroid.autostart = true;
      };
    })
  ];
}
