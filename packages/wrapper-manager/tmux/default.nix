# SPDX-FileCopyrightText: 2025 Fernando Ayats
# SPDX-License-Identifier: LicenseRef-MIT-AYATS

{ pkgs, lib, ... }:
let
  plugins = with pkgs.tmuxPlugins; [
  ];
in
{
  wrappers.tmux = {
    basePackage = pkgs.tmux;
    prependFlags = [
      "-f"
    ];
    wrapperType = "shell";
    wrapFlags = [
      "--run"
      "export TMUX_TMPDIR=$XDG_RUNTIME_DIR"
    ];
  };
}
