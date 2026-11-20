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
          bonnie
          dmidecode
          dnsutils
          file
          findutils
          gtop
          hwinfo
          lm_sensors
          lshw
          lsscsi
          magic-wormhole
          pciutils
          picocom
          pstree
          rsync
          shellcheck
          smartmontools
          snapper
          stable.snort
          sysstat
          tldr
          tree
          unzip
          usbutils
          wl-clipboard
          zip
        ];

        programs = {
          autojump = {
            enable = lib.mkDefault true;
            enableBashIntegration = lib.mkDefault true;
          };
          command-not-found.enable = lib.mkDefault true;
          direnv = {
            enable = lib.mkDefault true;
            enableBashIntegration = lib.mkDefault true;
            nix-direnv.enable = lib.mkDefault true;
          };
          dircolors = {
            enable = lib.mkDefault true;
            enableBashIntegration = lib.mkDefault true;
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
          gpg.enable = lib.mkDefault true;
          htop = {
            enable = lib.mkDefault true;
            settings = {
              color_scheme = lib.mkDefault 6;
              cpu_count_from_zero = lib.mkDefault true;
              highlight_base_name = lib.mkDefault true;
              highlight_megabytes = lib.mkDefault true;
              highlight_threads = lib.mkDefault true;
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
          man.enable = lib.mkDefault true;
          ptyxis.enable = lib.mkDefault true;
          ripgrep.enable = lib.mkDefault true;
          tmux = {
            enable = lib.mkDefault true;
            aggressiveResize = lib.mkDefault true;
            clock24 = lib.mkDefault true;
            escapeTime = lib.mkDefault 200;
            historyLimit = lib.mkDefault 5000;
            keyMode = lib.mkDefault "vi";
            newSession = lib.mkDefault true;
            sensibleOnTop = lib.mkDefault true;
            shortcut = lib.mkDefault "a";
            terminal = lib.mkDefault "tmux-direct";
            extraConfig = lib.mkDefault ''
              set -as terminal-overrides ',xterm-256color:RGB'
              set -g terminal-overrides 'xterm*:smcup@:rmcup@'
              set -g mouse on

              # remove when fixed: https://github.com/nix-community/home-manager/issues/5952
              set -gu default-command
              set -g default-shell "$SHELL"
            '';
            plugins = with pkgs.tmuxPlugins; [
              nord
              tmux-colors-solarized
              vim-tmux-navigator
              {
                plugin = yank;
                extraConfig = ''
                  bind -T copy-mode    C-c send -X copy-pipe-no-clear "xsel -i --clipboard"
                  bind -T copy-mode-vi C-c send -X copy-pipe-no-clear "xsel -i --clipboard"
                '';
              }
              {
                plugin = resurrect;
                extraConfig = "set -g @resurrect-strategy-nvim 'session'";
              }
            ];
          };
        };
      }

      (lib.mkIf cfg.bash.enable {
        home.packages = with pkgs; [
          bash-completion
          bashInteractive
        ];

        programs.bash = {
          enable = lib.mkDefault true;
          sessionVariables = {
            CLICOLOR = lib.mkDefault 1;
            COLORTERM = lib.mkDefault "truecolor";
            # Required for remote sudo authentication on target host.
            SSH_OPTS = lib.mkDefault "-tt";
          };
          shellAliases = import ./shell/shell-aliases.nix // import ./shell/shell-aliases-custom.nix;
          profileExtra = lib.mkDefault ''
            eval "$(direnv hook bash)"
          '';
        };
      })

      (lib.mkIf cfg.ollama.enable {
        # Enable Ollama framework for local large language model deployments.
        services.ollama.enable = lib.mkDefault true;
        # Disable Ollama service at startup.
        systemd.user.services.ollama.Install.WantedBy = lib.mkIf (!cfg.ollama.autostart) (lib.mkForce [ ]);
      })
    ]
  );
}
