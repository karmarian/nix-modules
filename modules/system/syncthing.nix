# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.syncthing = {
    enable = lib.mkEnableOption "Syncthing app and service";
  };

  config = lib.mkIf config.mine.module.system.syncthing.enable {
    environment.systemPackages = with pkgs; [
      syncthing
    ];

    # :TODO: Input optional attributes to customize devices, keys and IDs.
    services.syncthing = {
      enable = true;
      # overrides any devices added or deleted through the WebUI
      overrideDevices = lib.mkDefault true;
      # overrides any folders added or deleted through the WebUI
      overrideFolders = lib.mkDefault true;
    };

    # Open ports in the firewall.
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall.allowedTCPPorts = [
      8384
      22000
    ];
    networking.firewall.allowedUDPPorts = [
      22000
      21027
    ];
  };
}
