# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Configuration for this repo
# See ./modules/personal.nix for module options.
{ config, ... }:

let
  cfg = config.mine;

in
{
  imports = [
    ./modules/personal.nix
  ];

  config = {
    mine.userVm = {
      username = "me";
      fullname = "Me";
      uid = 1000;
      email = "me@vm.de";
      sshKey = "ssh-ed25519";
    };

    mine.machineVm = {
      hostname = "vm";
      arch = "x86_64-linux";
      cores = 2;
      memorySize = 4 * 1024;
      xkbLayout = "de";
      xkbVariant = "";
      timeZone = "Europe/Berlin";
      extraLocale = "de_DE.UTF-8";
    };

    mine.peripheralVm = {
      backupDevice = "bak";
      syncDevice = "host";
    };

    # Append custom configurations.

  };
}
