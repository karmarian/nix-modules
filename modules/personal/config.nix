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
          "adbusers"
          "audio"
          "kvm"
          "libvirt"
          "lp"
          "networkmanager"
          "video"
          "wheel"
          "wireshark"
        ];
        email = "me@vm.de";
        sshKey = "ssh-ed25519";
      };

      machineSubmodule.machineVm = {
        hostname = "vm";
        arch = "x86_64-linux";
        cores = 2;
        memorySize = 4 * 1024;
        xkbLayout = "de";
        xkbVariant = "";
        timeZone = "Europe/Berlin";
        extraLocale = "de_DE.UTF-8";
      };

      peripheralSubmodule.peripheralVm = {
        backupDevice = "bak";
        syncDevice = "host";
      };
    };
  };
}
