# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, pkgs, ... }:

let
  inherit (config.mine.userSubmodule.userVm) username isNormalUser extraGroups;
  inherit (config.mine.machineSubmodule.machineWsl)
    defaultLocale
    extraLocale
    hostname
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

  # Set the time zone.
  time.timeZone = "${timeZone}";

  # Select internationalisation properties.
  i18n.defaultLocale = "${defaultLocale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${extraLocale}";
    LC_IDENTIFICATION = "${extraLocale}";
    LC_MEASUREMENT = "${extraLocale}";
    LC_MONETARY = "${extraLocale}";
    LC_NAME = "${extraLocale}";
    LC_NUMERIC = "${extraLocale}";
    LC_PAPER = "${extraLocale}";
    LC_TELEPHONE = "${extraLocale}";
    LC_TIME = "${extraLocale}";
  };

  # Use the same keyboard layout in consoles as in the desktop.
  console.useXkbConfig = true;

  users.users = {
    ${username} = {
      isNormalUser = isNormalUser;
      description = "${username}";
      extraGroups = extraGroups;
      packages = with pkgs; [
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # List services that you want to enable:
  services = {
    # Xserver, but actually really wayland.
    # Set this to your own layout (run `setxkbmap -query`).
    xserver.xkb = {
      layout = "${xkbLayout}";
      variant = "${xkbVariant}";
    };
  };

  # NixOS system gets customized by system modules, which are enabled here.
  mine.module.system = {
    nix = {
      enable = true;
      store-optimisation.enable = true;
    };
    pipewire.enable = true;
    shell.enable = true;
    virtualisation.enable = true;
    zram.enable = true;
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
