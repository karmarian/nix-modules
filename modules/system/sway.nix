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
    environment.systemPackages = with pkgs; [
      # Notification utility.
      mako
      # Screenshot functionality.
      flameshot
      # Copy/paste functionality.
      wl-clipboard
    ];

    security = {
      polkit.enable = true;
      pam.services = {
        greetd.enableGnomeKeyring = true;
        swaylock.enableGnomeKeyring = true;
      };
    };

    services = {
      # Enable Gnome keyring to store secrets for apps.
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

    programs = {
      light.enable = true;
      sway = {
        enable = true;
        extraPackages = with pkgs; [
          adwaita-icon-theme
        ];
        wrapperFeatures.gtk = true;
      };
      waybar.enable = true;
    };

    systemd.user.services.kanshi = {
      description = "kanshi daemon";
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        DISPLAY = ":0";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kanshi}/bin/kanshi -c kanshi_config_file";
      };
    };

    hardware.graphics.enable = true;

    users.users.${cfg.userName}.extraGroups = [ "video" ];
  };
}
