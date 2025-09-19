# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  ...
}:

let
  cfg = config.mine.module.home.home-manager;

in
{
  options.mine.module.home.home-manager = {
    enable = lib.mkEnableOption "Home-manager config";
    auto-expire = lib.mkEnableOption "Scheduled generation expiration and cleanup";
    auto-upgrade = lib.mkEnableOption "Scheduled automatic channel upgrade and switch";
    standalone = lib.mkEnableOption "Let home-manager manage itself";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        nix.gc = {
          automatic = true;
          frequency = "weekly";
          randomizedDelaySec = "30min";
        };

      }

      (lib.mkIf cfg.auto-expire {
        services.home-manager.autoExpire = {
          enable = true;
          store.cleanup = true;
        };
      })

      (lib.mkIf cfg.auto-upgrade {
        services.home-manager.autoUpgrade = {
          enable = true;
          frequency = "weekly";
        };
      })

      (lib.mkIf cfg.standalone {
        programs.home-manager = {
          enable = true;
        };
      })
    ]
  );
}
