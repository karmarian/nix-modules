# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.locale;

in
{
  options.mine.module.system.locale = {
    enable = lib.mkEnableOption "Locale config";
    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Default system-wide locale";
    };
    extraLocales = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Support additional locales";
    };
    extraLocaleSet = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Partial set for extra locale settings";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Time zone setting";
    };
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout";
    };
  };

  config = lib.mkIf cfg.enable {
    # Set the time zone (run `tzselect`).
    time.timeZone = cfg.timeZone;

    # Select the default system-wide locale.
    i18n.defaultLocale = cfg.defaultLocale;

    # Support additional locales.
    i18n.extraLocales = cfg.extraLocales;

    # Individually set internationalisation options based on the default LANG
    # setting and some opinionated extra settings, which might need a different locale.
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocaleSet;
      LC_COLLATE = cfg.defaultLocale;
      LC_CTYPE = cfg.defaultLocale;
      LC_IDENTIFICATION = cfg.defaultLocale;
      LC_MEASUREMENT = cfg.extraLocaleSet;
      LC_MESSAGES = cfg.defaultLocale;
      LC_MONETARY = cfg.defaultLocale;
      LC_NAME = cfg.defaultLocale;
      LC_NUMERIC = cfg.defaultLocale;
      LC_PAPER = cfg.extraLocaleSet;
      LC_TELEPHONE = cfg.extraLocaleSet;
      LC_TIME = cfg.defaultLocale;
    };

    console = lib.mkIf (config.services.xserver.enable == false) {
      keyMap = cfg.keyboardLayout;
    };
  };
}
