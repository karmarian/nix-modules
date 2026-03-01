# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.syncthing;

in
{
  options.mine.module.home.syncthing = {
    enable = lib.mkEnableOption "Syncthing app and service";
    pregeneratedFiles = lib.mkEnableOption "Key and cert files already generated";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Syncthing user";
    };
    syncDevice = lib.mkOption {
      type = lib.types.str;
      default = "mysync";
      description = "Sync device name";
    };
    syncDeviceId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Sync device ID";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = lib.mkDefault true;
      # At first, "syncthing generate" is required to generate these keys.
      key = lib.mkIf (cfg.pregeneratedFiles) (
        lib.mkDefault "/home/${cfg.userName}/.local/state/syncthing/key.pem"
      );
      cert = lib.mkIf (cfg.pregeneratedFiles) (
        lib.mkDefault "/home/${cfg.userName}/.local/state/syncthing/cert.pem"
      );
      # Overrides any devices added or deleted through the WebUI.
      overrideDevices = lib.mkDefault true;
      # Overrides any folders added or deleted through the WebUI.
      overrideFolders = lib.mkDefault true;
      settings = {
        devices = {
          "${cfg.syncDevice}" = {
            id = cfg.syncDeviceId;
          };
        };
        folders = {
          # Name of folder in Syncthing, also the folder ID
          "share" = {
            # Which folder to add to Syncthing
            path = "/home/${cfg.userName}/syncthing/share";
            # Which devices to share the folder with
            devices = [ "${cfg.syncDevice}" ];
          };
        };
      };
    };
  };
}
