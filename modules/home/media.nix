# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  home,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.media;

in
{
  options.mine.module.home.media = {
    enable = lib.mkEnableOption "Media apps";
    mpd.enable = lib.mkEnableOption "Media player daemon";
    gstreamer.enable = lib.mkEnableOption "Gstreamer app and plugins";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          abcde
          audacious
          audacity
          ffmpeg
          jellyfin-desktop
          unstable.freetube
          millisecond
          vlc
        ];
      }

      (lib.mkIf cfg.mpd.enable {
        home.packages = with pkgs; [
          mpd
        ];

        services.mpd = {
          enable = lib.mkDefault true;
          musicDirectory = lib.mkDefault "${config.home.homeDirectory}/music";
        };
      })

      (lib.mkIf cfg.gstreamer.enable {
        home.packages = with pkgs; [
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-plugins-bad
        ];
      })
    ]
  );
}
