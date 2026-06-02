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
    ./desktop.nix
    ./emacs.nix
    ./git.nix
    ./gnome.nix
    ./home-manager.nix
    ./media.nix
    ./music.nix
    ./programming.nix
    ./shell.nix
    ./ssh.nix
    ./syncthing.nix
    ./tex.nix
    ./vim.nix
  ];

  options.mine.module.home.default = {
    scheme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Enable supported scheme like 'all', 'gnome' or 'headless'";
    };
  };

  config.mine.module.home = lib.mkMerge [
    (lib.mkIf (config.mine.module.home.default.scheme == "all") {
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
      tex.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "gnome") {
      desktop = {
        enable = true;
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
      };
      shell = {
        enable = true;
        bash.enable = true;
      };
      ssh.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "headless") {
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
      shell = {
        enable = true;
        bash.enable = true;
        ollama.enable = true;
        ollama.autostart = true;
      };
      ssh.enable = true;
      vim.enable = true;
    })
    (lib.mkIf (config.mine.module.home.default.scheme == "phone") {
      desktop = {
        enable = true;
        utils.enable = true;
      };
      home-manager = {
        enable = true;
        auto-expire = true;
        auto-upgrade = false;
        standalone = true;
      };
      shell = {
        enable = true;
        bash.enable = true;
      };
      syncthing = {
        enable = false;
        pregeneratedFiles = false;
      };
      vim.enable = true;
    })
  ];
}
