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
      default = "de";
      description = "Xserver keyboard layout";
    };
    xkbVariant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Xserver keyboard variant";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services = {
          # Enable the XServer windowing system, but actually really wayland.
          xserver.enable = true;

          # Enable the GNOME Desktop Environment.
          xserver.displayManager.gdm.enable = true;
          xserver.desktopManager.gnome = {
            enable = true;
          };
          # Set this to your own layout (run `setxkbmap -query`).
          xserver.xkb = {
            layout = cfg.xkbLayout;
            variant = cfg.xkbVariant;
          };
        };

        # Use the same keyboard layout in consoles as in the desktop.
        console.useXkbConfig = true;

        environment = {
          systemPackages = with pkgs; [
            gnome-connections
            gnome-tweaks
            nautilus
          ];

          gnome.excludePackages = with pkgs; [
            gnome-tour
          ];
        };

        programs = {
          gnome-terminal.enable = true;
        };

        services.gnome = {
          core-apps.enable = false;
          core-developer-tools.enable = false;
          games.enable = false;
        };

        # Enable networking.
        networking.networkmanager.enable = lib.mkDefault true;
      }

      (lib.mkIf cfg.autoLogin.enable {
        services = {
          xserver.displayManager.gdm.autoSuspend = false;
          displayManager.autoLogin = {
            enable = true;
            user = cfg.autoLogin.user;
          };
        };
        # Workaround for issue on 25.05 (https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229).
        systemd.services."getty@tty1".enable = false;
        systemd.services."autovt@tty1".enable = false;
      })
    ]
  );
}
