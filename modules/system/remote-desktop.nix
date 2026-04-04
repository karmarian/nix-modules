# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.remote-desktop;

in
{
  options.mine.module.system.remote-desktop = {
    enable = lib.mkEnableOption "Remote desktop apps";
    rdp.enable = lib.mkEnableOption "Remote desktop protocol";
    weylus.enable = lib.mkEnableOption "Graphical tablet/touch screen";
    weylus.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users for Weylus stylus and multi-touch support";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.rdp.enable {
        # Enable the GNOME RDP components.
        services.gnome.gnome-remote-desktop.enable = lib.mkDefault true;

        # Ensure the service starts automatically at boot so the settings panel appears.
        systemd.services.gnome-remote-desktop = {
          wantedBy = lib.mkDefault [ "graphical.target" ];
        };

        # Open the default RDP port (3389).
        networking.firewall.allowedTCPPorts = lib.mkDefault [ 3389 ];

        # Disable autologin to avoid session conflicts.
        services.displayManager.autoLogin.enable = lib.mkDefault false;
        services.getty.autologinUser = lib.mkDefault null;

        # Disable systemd targets for sleep and hibernation.
        systemd.targets.sleep.enable = lib.mkDefault false;
        systemd.targets.suspend.enable = lib.mkDefault false;
        systemd.targets.hibernate.enable = lib.mkDefault false;
        systemd.targets.hybrid-sleep.enable = lib.mkDefault false;
      })
      (lib.mkIf cfg.weylus.enable {
        programs.weylus = {
          enable = true;
          openFirewall = true;
          users = cfg.weylus.users;
        };
      })
    ]
  );
}
