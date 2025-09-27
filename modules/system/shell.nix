# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.shell;

in
{
  options.mine.module.system.shell = {
    enable = lib.mkEnableOption "Shell utilities";
    autoLogin.enable = lib.mkEnableOption "Auto login into TTY session";
    autoLogin.user = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Auto login username";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          gparted
          vim
          wget
        ];

        programs = {
          screen = {
            enable = true;
            screenrc = "
          truecolor on
        ";
          };
          mtr.enable = true;
        };
      }

      (lib.mkIf cfg.autoLogin.enable {
        # Auto-login the default user on consoles.
        services.getty.autologinUser = cfg.autoLogin.user;
      })
    ]
  );
}
