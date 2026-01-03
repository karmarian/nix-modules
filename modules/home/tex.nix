# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.tex;

in
{
  options.mine.module.home.tex = {
    enable = lib.mkEnableOption "LaTex application";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Mostly required by pandoc when creating PDFs.
      inkscape
      texlive.combined.scheme-tetex
      librsvg
    ];

    programs.pandoc.enable = lib.mkDefault true;
  };
}
