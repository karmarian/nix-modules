# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.remote-desktop = {
    enable = lib.mkEnableOption "Remote desktop apps";
  };

  config = lib.mkIf config.mine.module.system.remote-desktop.enable {
    # Enable the GNOME RDP components.
    services.gnome.gnome-remote-desktop.enable = true;

    # Ensure the service starts automatically at boot so the settings panel appears.
    systemd.services.gnome-remote-desktop = {
      wantedBy = [ "graphical.target" ];
    };

    # Open the default RDP port (3389).
    networking.firewall.allowedTCPPorts = [ 3389 ];

    # Disable autologin to avoid session conflicts.
    services.displayManager.autoLogin.enable = lib.mkDefault false;
    services.getty.autologinUser = lib.mkDefault null;

    # Disable systemd targets for sleep and hibernation.
    systemd.targets.sleep.enable = lib.mkDefault false;
    systemd.targets.suspend.enable = lib.mkDefault false;
    systemd.targets.hibernate.enable = lib.mkDefault false;
    systemd.targets.hybrid-sleep.enable = lib.mkDefault false;
  };
}
