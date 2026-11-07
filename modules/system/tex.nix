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
      texliveFull
    ];

    fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-sans
      source-code-pro
    ];
  };
}
