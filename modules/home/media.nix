# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.media = {
    enable = lib.mkEnableOption "Media apps";
  };

  config = lib.mkIf config.mine.module.home.media.enable {
    home.packages = with pkgs; [
      abcde
      audacious
      audacity
      ffmpeg
      freetube
      mpd
      vlc
    ];
  };
}
