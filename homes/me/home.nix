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
  mine.module.home.all.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Compatibility of home configuration with Home Manager release.
  home.stateVersion = "23.11";
}
