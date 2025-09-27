# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.jellyfin;

in
{
  options.mine.module.system.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Jellyfin username";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      user = cfg.userName;
      group = "users";
      # Open ports for jellyfin server automatically.
      openFirewall = true;
    };
  };
}
