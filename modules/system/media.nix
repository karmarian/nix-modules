# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.media;

in
{
  options.mine.module.system.media = {
    enable = lib.mkEnableOption "Media apps";
    mpd = {
      enable = lib.mkEnableOption "Media player daemon";
      username = lib.mkOption {
        type = lib.types.str;
        description = "Username whose home directory will be used for music";
        default = "me";
      };
      musicSubdir = lib.mkOption {
        type = lib.types.str;
        description = "Subdirectory in user's home for music";
        default = "music";
      };
    };
    gstreamer.enable = lib.mkEnableOption "Gstreamer app and plugins";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          abcde
          audacious
          audacity
          ffmpeg
          unstable.freetube
          millisecond
          vlc
        ];
      }

      (lib.mkIf cfg.mpd.enable {
        environment.systemPackages = with pkgs; [
          mpd
        ];

        services.mpd = {
          enable = lib.mkDefault true;
          musicDirectory = "/home/${cfg.mpd.username}/${cfg.mpd.musicSubdir}";
        };
      })

      (lib.mkIf cfg.gstreamer.enable {
        environment.systemPackages = with pkgs; [
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
