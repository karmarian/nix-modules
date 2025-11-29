# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.audiobookshelf;

in
{
  options.mine.module.system.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobook and podcast server";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "audiobookshelf";
      description = "audiobookshelf user";
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      dataDir = "audiobookshelf";
      host = "localhost";
      port = 8000;
      user = cfg.userName;
      group = "audiobookshelf";
      openFirewall = true;
    };
  };
}
