# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.comms = {
    enable = lib.mkEnableOption "Communication apps";
  };

  config = lib.mkIf config.mine.module.home.comms.enable {
    home.packages = with pkgs; [
      element-desktop
      stable.jami
      signal-desktop-bin
    ];
  };
}
