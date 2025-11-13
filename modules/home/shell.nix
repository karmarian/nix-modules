# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.shell;

in
{
  options.mine.module.home.shell = {
    enable = lib.mkEnableOption "Shell utilities";
    bash.enable = lib.mkEnableOption "Bash";
    ollama.enable = lib.mkEnableOption "Ollama natural language model";
    ollama.autostart = lib.mkEnableOption "Autostart Ollama service";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          alsa-utils
          dmidecode
          file
          gtop
          hwinfo
          lshw
          lsscsi
          magic-wormhole
          pciutils
          picocom
          pstree
          rsync
          snapper
          tldr
          unzip
          usbutils
          zip
        ];

        programs = {
          autojump = {
            enable = true;
            enableBashIntegration = true;
          };
          command-not-found.enable = true;
          direnv = {
            enable = true;
            enableBashIntegration = true;
            nix-direnv.enable = true;
          };
          dircolors = {
            enable = true;
            enableBashIntegration = true;
            settings = {
              DIR = "00;34";
              EXEC = "00;32";
              LINK = "00;36";
              SOCK = "00;35";
              PIPE = "00;33";
              BLK = "00;33";
              CHR = "00;33";
              ".tar" = "00;31";
              ".gz" = "00;31";
              ".zip" = "00;31";
              ".rar" = "00;31";
              ".jpg" = "00;35";
              ".png" = "00;35";
              ".gif" = "00;35";
            };
          };
          gpg.enable = true;
          htop = {
            enable = true;
            settings = {
              color_scheme = 6;
              cpu_count_from_zero = true;
              highlight_base_name = true;
              highlight_megabytes = true;
              highlight_threads = true;
            }
            // (
              with config.lib.htop;
              leftMeters [
                (bar "AllCPUs2")
                (bar "Memory")
                (bar "Swap")
                (bar "Battery")
              ]
            )
            // (
              with config.lib.htop;
              rightMeters [
                (text "Tasks")
                (text "LoadAverage")
                (text "Uptime")
                (text "CPU")
              ]
            );
          };
          man.enable = true;
          ptyxis.enable = true;
          ripgrep.enable = true;
        };
      }

      (lib.mkIf cfg.bash.enable {
        home.packages = with pkgs; [
          bash-completion
          bashInteractive
        ];

        programs.bash = {
          enable = true;
          sessionVariables = {
            CLICOLOR = 1;
            COLORTERM = "truecolor";
            # Required for remote sudo authentication on target host.
            SSH_OPTS = "-tt";
          };
          shellAliases = import ./shell/shell-aliases.nix // import ./shell/shell-aliases-custom.nix;
          profileExtra = ''
            eval "$(direnv hook bash)"
          '';
        };
      })

      (lib.mkIf cfg.ollama.enable {
        # Enable Ollama framework for local large language model deployments.
        services.ollama.enable = true;
        # Disable Ollama service at startup.
        systemd.user.services.ollama.Install.WantedBy = lib.mkIf (!cfg.ollama.autostart) (lib.mkForce [ ]);
      })
    ]
  );
}
