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
    ./tex.nix
    ./tmux.nix
    ./vim.nix
  ];

  options.mine.module.home.all = {
    enable = lib.mkEnableOption "All home apps";
  };

  config = lib.mkIf config.mine.module.home.all.enable {
    mine.module.home = {
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
        org = true;
        package = true;
        python = true;
        shell = true;
      };
      git.enable = true;
      gnome.enable = true;
      home-manager = {
        enable = true;
        auto-expire = true;
        auto-upgrade = true;
        standalone = true;
      };
      media = {
        enable = true;
        mpd.enable = true;
        gstreamer.enable = true;
      };
      music.enable = true;
      network = {
        enable = true;
        vpn.enable = true;
      };
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
      tex.enable = true;
      tmux.enable = true;
      vim.enable = true;
    };
  };
}
