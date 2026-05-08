# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.tex;

in
{
  options.mine.module.system.tex = {
    enable = lib.mkEnableOption "LaTex application";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Mostly required by pandoc when creating PDFs.
      inkscape
      librsvg
      pandoc
      texlive.combined.scheme-tetex
    ];
  };
}
