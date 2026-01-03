# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.immich;

in
{
  options.mine.module.system.immich = {
    enable = lib.mkEnableOption "Immich photo and video management";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "immich";
      description = "Immich user";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = lib.mkDefault true;
      port = lib.mkDefault 2283;
      host = lib.mkDefault "localhost";
      mediaLocation = lib.mkDefault "/var/lib/immich";
      openFirewall = lib.mkDefault true;
      user = cfg.userName;
    };
  };
}
