# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.ssh = {
    enable = lib.mkEnableOption "SSH config";
  };

  config = lib.mkIf config.mine.module.home.ssh.enable {
    programs.ssh = {
      enable = true;
    };

    services = {
      ssh-agent = {
        enable = true;
      };

      gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
    };
  };
}
