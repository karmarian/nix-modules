# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.emacs;

in
{
  options.mine.module.home.emacs = {
    enable = lib.mkEnableOption "Emacs with modules and dependencies";
    comms = lib.mkEnableOption "Communication modules";
    core = lib.mkEnableOption "Core modules";
    dev = lib.mkEnableOption "Development modules";
    evil = lib.mkEnableOption "Evil modules";
    music = lib.mkEnableOption "Music modules";
    org = lib.mkEnableOption "Org modules";
    package = lib.mkEnableOption "Package management modules";
    python = lib.mkEnableOption "Python modules";
    shell = lib.mkEnableOption "Shell modules";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.emacs = {
          enable = lib.mkDefault true;
        };

        services.emacs = {
          enable = lib.mkDefault true;
          client = {
            enable = lib.mkDefault true;
          };
          socketActivation.enable = lib.mkDefault true;
          defaultEditor = lib.mkDefault false;
        };
      }

      (lib.mkIf cfg.comms {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            ement
          ];
      })

      (lib.mkIf cfg.core {
        home.packages = with pkgs; [
          source-code-pro
        ];

        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            clipetty
            vertico
            which-key
          ];
      })

      (lib.mkIf cfg.dev {
        home.packages = with pkgs; [
          clang-tools
          cmake
          direnv
          ghostscript
          git
          global
          guile
          universal-ctags
        ];

        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            auctex
            apheleia
            build-farm
            clang-format
            cmake-font-lock
            cmake-ide
            cmake-mode
            cmake-project
            company
            daemons
            diff-hl
            direnv
            docker
            dockerfile-mode
            dts-mode
            eglot
            exec-path-from-shell
            geiser
            geiser-guile
            git-link
            ggtags
            guix
            hydra
            iedit
            lispy
            lispyville
            markdown-mode
            multiple-cursors
            nix-mode
            rainbow-delimiters
            rust-mode
            smartparens
            undo-tree
            visual-fill-column
            yaml
            yasnippet
            yasnippet-snippets
          ];
      })

      (lib.mkIf cfg.evil {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            evil
            evil-collection
            evil-org
          ];
      })

      (lib.mkIf cfg.music {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            emms
          ];
      })

      (lib.mkIf cfg.org {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            org
            org-roam
          ];
      })

      (lib.mkIf cfg.package {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            use-package
          ];
      })

      (lib.mkIf cfg.python {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            elpy
          ];
      })

      (lib.mkIf cfg.shell {
        programs = {
          # Eat requires to run an init script for proper shell integration.
          # :WARNING: The script is only sourced for bash in this case.
          bash = {
            bashrcExtra = ''
              [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
                source "$EAT_SHELL_INTEGRATION_DIR/bash"
            '';
          };
          emacs.extraPackages =
            epkgs: with epkgs; [
              eat
              eshell-z
              esh-autosuggest
              xterm-color
              exec-path-from-shell
              pcmpl-args
              eshell-syntax-highlighting
              eshell-toggle
              vterm
            ];
        };
      })
    ]
  );
}
