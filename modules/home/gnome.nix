# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.gnome = {
    enable = lib.mkEnableOption "Gnome apps and configs";
  };

  config = lib.mkIf config.mine.module.home.gnome.enable {
    home.packages = with pkgs; [
      gnome-tweaks
    ];

    # :TODO: Gnome-terminal and dconf settings in system or user configuration.
    # programs.gnome-terminal = {
    #   enable = lib.mkDefault true;
    #   themeVariant = lib.mkDefault "light";
    #   showMenubar = lib.mkDefault false;
    #   profile.1b95c7da-cfb3-422a-8707-d849eed2aa44 = {
    #     default = lib.mkDefault true;
    #     visibleName = lib.mkDefault "Default";
    #   };
    # };

    # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
    # Use `dconf watch /` to track stateful changes you are doing
    # (e.g. in dconf-editor), then set them here.
    # Use `dconf dump /org/gnome/desktop/wm/` to see current values.
    dconf.settings = {
      # Don't show a welcome dialog
      "org/gnome/shell" = {
        welcome-dialog-last-shown-version = "9999999999";
      };

      # # No timeouts
      "org/gnome/desktop/session" = {
        idle-delay = lib.mkDefault 0;
      };

      # Make Caps Lock an additional Esc.
      "org/gnome/desktop/input-sources" = {
        xkb-options = lib.mkDefault [ "caps:escape" ];
        # german and english keyboard layout
        show-all-sources = lib.mkDefault true;
        sources = lib.mkDefault [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "de"
          ])
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "us"
          ])
        ];
      };

      "org/gnome/desktop/sound" = {
        event-sounds = lib.mkDefault false;
      };

      # Disbale sound you get when trying to delete more in text field than exist.
      "org/gnome/desktop/wm/preferences" = {
        audible-bell = lib.mkDefault false;
      };

      # Faster key repeat
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.mkDefault 200;
        repeat-interval = lib.mkDefault 25;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = lib.mkDefault true;
        speed = lib.mkDefault 1.0;
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = lib.mkDefault true;
      };

      # Make media key changes always silent.
      "org/gnome/settings-daemon/plugins/media-keys" = {
        volume-mute-quiet-static = lib.mkDefault [ "XF86AudioMute" ];
        volume-down-quiet-static = lib.mkDefault [ "XF86AudioLowerVolume" ];
        volume-up-quiet-static = lib.mkDefault [ "XF86AudioRaiseVolume" ];
      };

      # Set dim and sleep configurations.
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = lib.mkDefault true;
        sleep-inactive-battery-type = lib.mkDefault "suspend";
        sleep-inactive-battery-timeout = lib.mkDefault "1800";
        sleep-inactive-ac-type = lib.mkDefault "nothing";
      };
    };
  };
}
