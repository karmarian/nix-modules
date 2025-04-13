# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.shell-utils = {
    enable = lib.mkEnableOption "Shell utilities";
  };

  config = lib.mkIf config.mine.module.system.shell-utils.enable {
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

    # Enable Ollama framework for local large language model deployments.
    services.ollama.enable = true;
  };
}
