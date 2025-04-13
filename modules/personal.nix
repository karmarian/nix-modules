# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Top-level configuration for everything in this repo.
#
# Values are set in 'config.nix' in repo root.
{ lib, ... }:

let
  userSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "me";
      };
      fullname = lib.mkOption {
        type = lib.types.str;
        default = "Me";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        default = 1000;
      };
      isNormalUser = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "me@vm.de";
      };
      sshKey = lib.mkOption {
        type = lib.types.str;
        description = ''
          SSH public key
        '';
        default = "ssh-ed25519";
      };
    };
  };

  machineSubmodule = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "vm";
      };
      arch = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
      };
      cores = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
      memorySize = lib.mkOption {
        type = lib.types.int;
        default = 4 * 1024;
      };
      xkbLayout = lib.mkOption {
        type = lib.types.str;
        default = "de";
      };
      xkbVariant = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
      };
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
      };
      extraLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
      };
    };
  };

  peripheralSubmodule = lib.types.submodule {
    options = {
      backupDevice = lib.mkOption {
        type = lib.types.str;
        default = "bak";
      };
      syncDevice = lib.mkOption {
        type = lib.types.str;
        default = "vm";
      };
    };
  };

in
{
  options = {
    mine.userVm = lib.mkOption {
      type = userSubmodule;
    };

    mine.machineVm = lib.mkOption {
      type = machineSubmodule;
    };

    mine.peripheralVm = lib.mkOption {
      type = peripheralSubmodule;
    };

    # Append custom options.

  };
}
