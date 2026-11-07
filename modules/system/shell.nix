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
    bash.enable = lib.mkEnableOption "Bash";
    ollama.enable = lib.mkEnableOption "Ollama natural language model";
    ollama.autostart = lib.mkEnableOption "Autostart Ollama service";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          alsa-utils
          autojump
          bonnie
          dmidecode
          dnsutils
          file
          gparted
          gtop
          hwinfo
          htop
          lm_sensors
          findutils
          lshw
          lsscsi
          magic-wormhole
          man
          mtr
          pciutils
          picocom
          pstree
          ptyxis
          ripgrep
          rsync
          screen
          shellcheck
          smartmontools
          snapper
          snort
          sysstat
          tldr
          tmux
          tree
          unzip
          usbutils
          vim
          wget
          xsel # for tmux-yank
          zip
        ];

        programs = {
          command-not-found.enable = lib.mkDefault true;
          direnv = {
            enable = lib.mkDefault true;
            enableBashIntegration = lib.mkDefault true;
            nix-direnv.enable = lib.mkDefault true;
          };
          gnupg.agent.enable = lib.mkDefault true;
        };

        services.locate.enable = lib.mkDefault true;
      }

      (lib.mkIf cfg.autoLogin.enable {
        # Auto-login the default user on consoles.
        services.getty.autologinUser = cfg.autoLogin.user;
      })

      (lib.mkIf cfg.bash.enable {
        environment.systemPackages = with pkgs; [
          bash-completion
          bashInteractive
        ];

        programs.bash = {
          enable = lib.mkDefault true;
        };
      })

      (lib.mkIf cfg.ollama.enable {
        # Enable Ollama framework for local large language model deployments.
        services.ollama.enable = lib.mkDefault true;

        # Disable Ollama service at startup.
        systemd.services.ollama = lib.mkIf (!cfg.ollama.autostart) {
          wantedBy = lib.mkForce [ ];
        };
      })
    ]
  );
}
