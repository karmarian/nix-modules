# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.mine.userSubmodule.userVm) username isNormalUser extraGroups;
  inherit (config.mine.machineSubmodule.machineWsl)
    cores
    defaultLocale
    extraLocaleSet
    hostname
    memorySize
    timeZone
    xkbLayout
    xkbVariant
    ;

in
{

  imports = [
    ../../modules/system
    ../../modules/wsl
  ];

  networking.hostName = "${hostname}"; # Define your hostname.

  users.users = {
    ${username} = {
      isNormalUser = isNormalUser;
      description = "${username}";
      extraGroups = extraGroups;
      packages = with pkgs; [
      ];
    };
  };

  # NixOS system gets customized by system modules, which are enabled here.
  mine.module.system = {
    default.scheme = "headless";
    audiobookshelf = {
      userName = username;
    };
    boot.enable = lib.mkForce false;
    gnome = {
      autoLogin.user = username;
      xkbLayout = xkbLayout;
      xkbVariant = xkbVariant;
    };
    immich = {
      userName = username;
    };
    jellyfin = {
      userName = username;
    };
    locale = {
      defaultLocale = defaultLocale;
      extraLocaleSet = extraLocaleSet;
      timeZone = timeZone;
      keyboardLayout = xkbLayout;
    };
    shell = {
      autoLogin.user = username;
    };
    virtualisation = {
      vmCores = (cores / 2);
      vmMemorySize = (memorySize / 2);
    };
  };
  mine.module.wsl.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
