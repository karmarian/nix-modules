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
  inherit (config.mine.userSubmodule.userVm) username email scheme;
  inherit (config.mine.machineSubmodule.machineVm) xkbLayout;
  inherit (config.mine.peripheralSubmodule.peripheralVm)
    syncDevice
    syncDeviceId
    ;

in
{
  imports = [
    ../../modules/home
    ../../modules/personal/config.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # Home Manager gets customized by home modules, which are enabled here.
  mine.module.home = {
    default.scheme = scheme;
    git = {
      userName = username;
      userEmail = email;
    };
    gnome = {
      xkbLayout = xkbLayout;
    };
    syncthing = {
      userName = username;
      syncDevice = syncDevice;
      syncDeviceId = syncDeviceId;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Compatibility of home configuration with Home Manager release.
  home.stateVersion = "23.11";
}
