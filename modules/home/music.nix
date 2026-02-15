# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.music;

in
{
  options.mine.module.home.music = {
    enable = lib.mkEnableOption "Music apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ardour
      calf
      carla
      distrho-ports
      dragonfly-reverb
      fluidsynth
      guitarix
      hydrogen
      infamousPlugins
      lilypond
      lmms
      mda_lv2
      musescore
      qjackctl
      rosegarden
      solfege
      surge
      zynaddsubfx
    ];
  };
}
