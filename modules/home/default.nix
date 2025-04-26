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
    ./comms.nix
    ./container.nix
    ./desktop.nix
    ./emacs.nix
    ./git.nix
    ./gnome.nix
    ./git.nix
    ./gstreamer.nix
    ./media.nix
    ./music.nix
    ./network.nix
    ./programming.nix
    ./python.nix
    ./shell.nix
    ./ssh.nix
    ./tex.nix
    ./tmux.nix
    ./vim.nix
    ./vpn.nix
  ];

  options.mine.module.home.all = {
    enable = lib.mkEnableOption "All home apps";
  };

  config = lib.mkIf config.mine.module.home.all.enable {
    mine.module.home = {
      comms.enable = true;
      container.enable = true;
      desktop.enable = true;
      emacs.enable = true;
      git.enable = true;
      gnome.enable = true;
      gstreamer.enable = true;
      media.enable = true;
      music.enable = true;
      network.enable = true;
      programming.enable = true;
      python.enable = true;
      shell = {
        enable = true;
        bash.enable = true;
      };
      ssh.enable = true;
      tex.enable = true;
      tmux.enable = true;
      vim.enable = true;
      vpn.enable = true;
    };
  };
}
