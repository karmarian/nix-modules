# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.wsl = {
    enable = lib.mkEnableOption "Windows Subsystem for Linux config";
  };

  config = lib.mkIf config.mine.module.system.wsl.enable {
    wsl = {
      enable = lib.mkDefault true;
      defaultUser = lib.mkDefault "karmar";
      startMenuLaunchers = lib.mkDefault true;
      # WSL interoperability support required when using binfmt.
      interop.register = lib.mkDefault true;
      usbip.enable = lib.mkDefault true;
      usbip.autoAttach = lib.mkDefault [ "2-1" ];
    };

    systemd.services.wsl-vpnkit = {
      enable = lib.mkDefault true;
      description = "wsl-vpnkit";
      after = lib.mkDefault [ "network.target" ];
      wantedBy = lib.mkDefault [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.mkDefault "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
        Restart = lib.mkDefault "always";
        KillMode = lib.mkDefault "mixed";
      };
    };
  };
}
