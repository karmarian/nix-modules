# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Configuration for this repo
# See ./custom_config.nix to append custom settings.
{ config, lib, ... }:

{
  imports = [
    ./options.nix
    ./custom_config.nix
  ];

  config = {
    mine = {
      userSubmodule.userVm = {
        username = "me";
        fullname = "Me";
        uid = 1000;
        extraGroups = [
          "audio"
          "lp"
          "networkmanager"
          "video"
          "wheel"
        ];
        email = "me@vm.de";
        sshKey = "ssh-ed25519";
      };

      userSubmodule.userWsl = {
        username = "me";
        fullname = "Me";
        extraGroups = [
          "audio"
          "lp"
          "networkmanager"
          "video"
          "wheel"
        ];
        email = "me@wsl.de";
        sshKey = "ssh-ed25519";
      };

      machineSubmodule.machineVm = {
        hostname = "vm";
        arch = "x86_64-linux";
        cores = 4;
        memorySize = 16 * 1024;
        xkbLayout = "de";
        xkbVariant = "";
        timeZone = "Europe/Berlin";
        defaultLocale = "en_US.UTF-8";
        extraLocaleSet = "de_DE.UTF-8";
        scheme = "headless";
      };

      machineSubmodule.machineWsl = {
        hostname = "wsl";
        arch = "x86_64-linux";
        cores = 4;
        memorySize = 16 * 1024;
        xkbLayout = "de";
        xkbVariant = "";
        timeZone = "Europe/Berlin";
        defaultLocale = "en_US.UTF-8";
        extraLocaleSet = "de_DE.UTF-8";
        scheme = "headless";
      };

      peripheralSubmodule.peripheralVm = {
        backupDevice = "bak";
        syncDevice = "host";
        syncDeviceId = "";
      };
    };
  };
}
