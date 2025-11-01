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
      description = "Default locale setting";
    };
    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Extra locale setting";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Extra locale setting";
    };
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us_en";
      description = "Keyboard layout";
    };
  };

  config = lib.mkIf cfg.enable {
    # Set the time zone (run `tzselect`).
    time.timeZone = cfg.timeZone;

    # Select internationalisation properties.
    i18n.defaultLocale = cfg.defaultLocale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };

    console = lib.mkIf (config.services.xserver.enable == false) {
      keyMap = cfg.keyboardLayout;
    };
  };
}
