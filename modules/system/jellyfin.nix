# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";
  };

  config = lib.mkIf config.mine.module.system.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      group = "users";
      # Open ports for jellyfin server automatically.
      openFirewall = true;
    };
  };
}
