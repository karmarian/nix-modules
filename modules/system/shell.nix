# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.shell = {
    enable = lib.mkEnableOption "Shell utilities";
    ollama.autostart = lib.mkEnableOption "Autostart Ollama service";
  };

  config = lib.mkIf config.mine.module.system.shell.enable {
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
    # Disable Ollama service at startup.
    systemd.services.ollama.wantedBy = lib.mkIf (!config.mine.module.system.shell.ollama.autostart) (
      lib.mkForce [ ]
    );
  };
}
