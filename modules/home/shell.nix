# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  collectOld = pkgs.writeScriptBin "nix-collect-old" ''
    nix-env --delete-generations old
    nix-collect-garbage
    nix-collect-garbage -d
    nix-store --gc --print-dead
    nix-store --optimize
  '';
in
{
  options.mine.module.home.shell = {
    enable = lib.mkEnableOption "Shell utilities";
    bash.enable = lib.mkEnableOption "Bash";
    ollama.enable = lib.mkEnableOption "Ollama natural language model";
    ollama.autostart = lib.mkEnableOption "Autostart Ollama service";
  };

  config = lib.mkIf config.mine.module.home.shell.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          dmidecode
          file
          gtop
          hwinfo
          lshw
          lsscsi
          magic-wormhole
          pciutils
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
          };
          gpg.enable = true;
          htop = {
            enable = true;
            settings =
              {
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
          ripgrep.enable = true;
        };
      }

      (lib.mkIf config.mine.module.home.shell.bash.enable {
        home.packages = with pkgs; [
          bash-completion
          bashInteractive
        ];

        programs.bash = {
          enable = true;
          sessionVariables = {
            CLICOLOR = 1;
            COLORTERM = "truecolor";
            LSCOLORS = "GxFxCxDxBxegedabagaced";
            LC_ALL = "en_US.UTF-8";
            LANG = "en_US.UTF-8";
            # Required for remote sudo authentication on target host.
            SSH_OPTS = "-tt";
          };
          shellAliases = import ./shell/shell-aliases.nix // import ./shell/shell-aliases-custom.nix;
          profileExtra = ''
            eval "$(direnv hook bash)"
          '';
        };
      })

      (lib.mkIf config.mine.module.home.shell.ollama.enable {
        # Enable Ollama framework for local large language model deployments.
        services.ollama.enable = true;
        # Disable Ollama service at startup.
        systemd.user.services.ollama.Install.WantedBy = lib.mkIf (
          !config.mine.module.home.shell.ollama.autostart
        ) (lib.mkForce [ ]);
      })
    ]
  );
}
