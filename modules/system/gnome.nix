# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.gnome;

in
{
  options.mine.module.system.gnome = {
    enable = lib.mkEnableOption "GNOME config";
    autoLogin.enable = lib.mkEnableOption "Auto login into Gnome session";
    autoLogin.user = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Auto login username";
    };
    xkbLayout = lib.mkOption {
      type = lib.types.str;
      default = "de,us";
      description = "Xserver keyboard layout";
    };
    xkbVariant = lib.mkOption {
      type = lib.types.str;
      default = ",";
      description = "Xserver keyboard variant";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services = {
          # Enable the XServer windowing system, but actually really wayland.
          xserver.enable = lib.mkDefault true;

          # Enable the GNOME Desktop Environment.
          displayManager.gdm.enable = lib.mkDefault true;
          desktopManager.gnome = {
            enable = lib.mkDefault true;
          };
          # Set this to your own layout (run `setxkbmap -query`).
          xserver.xkb = {
            layout = cfg.xkbLayout;
            variant = cfg.xkbVariant;
            # Switch with Alt+Shift.
            options = "grp:alt_shift_toggle";
          };
        };

        # Use the same keyboard layout in consoles as in the desktop.
        console.useXkbConfig = lib.mkDefault true;

        environment = {
          systemPackages = with pkgs; [
            bustle
            gnome-tweaks
            gnome-weather
            gnomeExtensions.astra-monitor
            gnomeExtensions.appindicator
            pika-backup
            ptyxis
            warp
          ];

          gnome.excludePackages = with pkgs; [
            gnome-tour
          ];
        };

        services.gnome = {
          # Gnome desktop-manager service enables core-apps by default.
          core-apps.enable = true;
          core-developer-tools.enable = lib.mkDefault true;
          games.enable = lib.mkDefault false;
        };

        # Enable networking.
        networking.networkmanager.enable = lib.mkDefault true;
      }

      (lib.mkIf cfg.autoLogin.enable {
        services.displayManager = {
          gdm.autoSuspend = lib.mkDefault false;
          autoLogin = {
            enable = lib.mkDefault true;
            user = cfg.autoLogin.user;
          };
        };
        # Workaround for issue on 25.05 (https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229).
        systemd.services."getty@tty1".enable = lib.mkDefault false;
        systemd.services."autovt@tty1".enable = lib.mkDefault false;
      })
    ]
  );
}
