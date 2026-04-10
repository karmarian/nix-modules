# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./direnv/default.nix
    ./element/default.nix
    ./git/default.nix
    ./jami/default.nix
    ./keepassxc/default.nix
    ./signal/default.nix
    ./teleports/default.nix
    #./tmux/default.nix
    ./tor-browser/default.nix
    ./vim/default.nix
  ];
}
