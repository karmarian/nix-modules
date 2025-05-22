# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.music = {
    enable = lib.mkEnableOption "Music apps";
  };

  config = lib.mkIf config.mine.module.home.music.enable {
    home.packages = with pkgs; [
      stable.ardour
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
      stable.rosegarden
      stable.solfege
      surge
      zynaddsubfx
    ];
  };
}
