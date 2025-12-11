# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.sway;

in
{
  options.mine.module.system.sway = {
    enable = lib.mkEnableOption "Sway system dependencies";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Sway login user name";
    };
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;

    services = {
      gnome.gnome-keyring.enable = true;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
            user = cfg.userName;
          };
        };
      };
    };

    systemd.user.services.kanshi = {
      description = "kanshi daemon";
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        DISPLAY = ":0";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
      };
    };
  };
}
