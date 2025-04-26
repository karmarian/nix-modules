# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ lib, ... }:

{
  imports = [
    ./options.nix
  ];

  config = {
    mine = {
      userSubmodule = {
        # Add custom user settings.
      };

      machineSubmodule = {
        # Add custom machine settings.
      };

      peripheralSubmodule = {
        # Add custom periphery settings.
      };
    };
  };
}
