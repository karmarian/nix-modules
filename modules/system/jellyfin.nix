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
      default = "jellyfin";
      description = "Jellyfin user name";
    };
    groupName = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
      description = "Jellyfin group name";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = lib.mkDefault true;
      user = cfg.userName;
      group = cfg.groupName;
      # Open ports for jellyfin server automatically.
      openFirewall = lib.mkDefault true;
    };
  };
}
