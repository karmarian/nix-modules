# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ pkgs, ... }:

{
  wrappers.teleports = {
    basePackage = pkgs.lomiri.teleports;
    prependFlags = [
    ];
  };
}
