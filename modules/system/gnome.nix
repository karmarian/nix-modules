# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.gnome = {
    enable = lib.mkEnableOption "GNOME config";
  };

  config = lib.mkIf config.mine.module.system.gnome.enable {
    services = {
      # Enable the XServer windowing system, but actually really wayland.
      xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      xserver.displayManager.gdm.enable = true;
      xserver.desktopManager.gnome = {
        enable = true;
        # Set firefox and console as the apps in the dock
        favoriteAppsOverride = ''
          [org.gnome.shell]
          favorite-apps = [ 'firefox.desktop','org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop' ]
        '';

        # Enable touchpad support (enabled default in most desktopManager).
        # libinput.enable = true;
      };
    };

    environment = {
      gnome.excludePackages =
        (with pkgs; [
          gnome-tour
        ])
        ++ (with pkgs; [
          epiphany
          evince
          geary
          gedit
          gnome-console
          gnome-music
          totem
        ]);

      systemPackages = with pkgs; [
        gnome-boxes
        gnomeExtensions.astra-monitor
        gnomeExtensions.appindicator
      ];
    };

    programs = {
      gnome-terminal.enable = true;
    };

    # Enable networking
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
