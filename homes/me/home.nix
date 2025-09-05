# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (config.mine.userSubmodule.userVm) username;

in
{
  imports = [
    ../../modules/home
    ../../modules/personal/config.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [ ];

  # Manage plain dotfiles.
  home.file = { };

  # Manage environment session variables.
  home.sessionVariables = { };

  # Home Manager gets customized by home modules, which are enabled here.
  mine.module.home = {
    container.enable = false;
    desktop = {
      enable = false;
      comms.enable = false;
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
    gnome.enable = false;
    home-manager = {
      enable = true;
      auto-expire = true;
      auto-upgrade = false;
      standalone = false;
    };
    media = {
      enable = true;
      mpd.enable = false;
      gstreamer.enable = false;
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Compatibility of home configuration with Home Manager release.
  home.stateVersion = "23.11";
}
