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
    ./container.nix
    ./desktop.nix
    ./emacs.nix
    ./git.nix
    ./gnome.nix
    ./home-manager.nix
    ./media.nix
    ./music.nix
    ./network.nix
    ./programming.nix
    ./shell.nix
    ./ssh.nix
    ./sway.nix
    ./syncthing.nix
    ./tex.nix
    ./tmux.nix
    ./vim.nix
  ];

  options.mine.module.home.default = {
    scheme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Enable supported scheme like 'all', 'sway' or 'headless'";
    };
  };

  config.mine.module.home = lib.mkMerge [
    (lib.mkIf (config.mine.module.home.default.scheme == "all") {
      container.enable = true;
      desktop = {
        enable = true;
        comms.enable = true;
        extra-browser.enable = true;
      };
      emacs = {
        enable = true;
        comms = true;
        core = true;
        dev = true;
        evil = true;
        music = true;
        # :BUG: Upstream build issues.
        org = false;
        package = true;
        python = true;
        shell = true;
      };
      git = {
        enable = true;
      };
      gnome = {
        enable = true;
      };
      home-manager = {
        enable = true;
        auto-expire = true;
        auto-upgrade = false;
        standalone = false;
      };
      media = {
        enable = true;
        mpd.enable = true;
        gstreamer.enable = true;
      };
      music.enable = true;
      network.enable = true;
      programming = {
        enable = true;
        python.enable = true;
      };
      shell = {
        enable = true;
        bash.enable = true;
        ollama.enable = true;
        ollama.autostart = true;
      };
      ssh.enable = true;
      sway.enable = false;
      syncthing = {
        enable = true;
        pregeneratedFiles = false;
      };
      tex.enable = true;
      tmux.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "sway") {
      desktop = {
        enable = true;
      };
      git = {
        enable = true;
      };
      home-manager = {
        enable = true;
        auto-expire = true;
        auto-upgrade = false;
      };
      network = {
        enable = true;
        vpn.enable = true;
      };
      shell = {
        enable = true;
        bash.enable = true;
      };
      ssh.enable = true;
      sway.enable = true;
      tmux.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "headless") {
      emacs = {
        enable = true;
        comms = true;
        core = true;
        dev = true;
        evil = true;
        music = true;
        # :BUG: Upstream build issues.
        org = false;
        package = true;
        python = true;
        shell = true;
      };
      git = {
        enable = true;
      };
      home-manager = {
        enable = true;
        auto-expire = true;
        auto-upgrade = false;
        standalone = false;
      };
      media = {
        enable = true;
        mpd.enable = true;
        gstreamer.enable = true;
      };
      network.enable = true;
      programming = {
        enable = true;
        python.enable = true;
      };
      shell = {
        enable = true;
        bash.enable = true;
        ollama.enable = true;
        ollama.autostart = true;
      };
      ssh.enable = true;
      syncthing = {
        enable = true;
        pregeneratedFiles = false;
      };
      tmux.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "music") {
      gnome = {
        enable = true;
      };
      media = {
        enable = true;
      };
      music.enable = true;
    })
  ];
}
