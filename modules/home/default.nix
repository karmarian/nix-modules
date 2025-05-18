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
    ./git.nix
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
      };
      emacs.enable = true;
      git.enable = true;
      gnome.enable = true;
      media = {
        enable = true;
        mpd.enable = false;
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
        ollama.autostart = false;
      };
      ssh.enable = true;
      tex.enable = true;
      tmux.enable = true;
      vim.enable = true;
    };
  };
}
