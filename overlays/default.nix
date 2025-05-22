# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  package = self + /packages;

in
final: prev: { }
