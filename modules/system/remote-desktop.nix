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
    environment.systemPackages = with pkgs; [
      gnome-remote-desktop
    ];

    # Enable Remote Desktop server Protocol for using xserver.
    services.xrdp = {
      enable = true;
      defaultWindowManager = "gnome-remote-desktop";
      openFirewall = true;
    };
  };
}
