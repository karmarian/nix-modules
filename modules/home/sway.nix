# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.module.home.sway;

in
{
  options.mine.module.home.sway = {
    enable = lib.mkEnableOption "Sway Wayland compositor";
    xkbLayout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "Keyboard layout";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          # Launch Firefox on start
          { command = "firefox"; }
        ];
      };
    };
  };
}
