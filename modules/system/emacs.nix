# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.emacs;

in
{
  options.mine.module.system.emacs = {
    enable = lib.mkEnableOption "Emacs with modules and dependencies";
    comms = lib.mkEnableOption "Communication modules";
    core = lib.mkEnableOption "Core modules";
    dev = lib.mkEnableOption "Development modules";
    evil = lib.mkEnableOption "Evil modules";
    music = lib.mkEnableOption "Music modules";
    org = lib.mkEnableOption "Org modules";
    package = lib.mkEnableOption "Package management modules";
    shell = lib.mkEnableOption "Shell modules";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
            ]
          );
        };

        ## If you want it per-user instead of system-wide use
        ## 'users.users.&lt;name&gt;.packages = with pkgs; [' instead.
        environment.systemPackages = with pkgs; [
          myEmacs
        ];

        ## Enabling emacsclient and making all the packages available.
        services.emacs = {
          enable = true;
          package = pkgs.myEmacs;
        };
      }

      (lib.mkIf cfg.comms {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              ement
            ]
          );
        };
      })

      (lib.mkIf cfg.core {
        environment.systemPackages = with pkgs; [
          source-code-pro
        ];

        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              clipetty
              vertico
              which-key
            ]
          );
        };
      })

      (lib.mkIf cfg.dev {
        environment.systemPackages = with pkgs; [
          clang-tools
          cmake
          direnv
          ghostscript
          git
          global
          guile
          universal-ctags
        ];

        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
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
              nixmode
              pretty-sha-path
              rainbow-delimiters
              rust-mode
              smartparens
              undo-tree
              visual-fill-column
              yaml
              yasnippet
              yasnippet-snippets
            ]
          );
        };
      })

      (lib.mkIf cfg.evil {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              evil
              evil-collection
              evil-org
            ]
          );
        };
      })

      (lib.mkIf cfg.music {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              emms
            ]
          );
        };
      })

      (lib.mkIf cfg.org {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              org
              org-roam
            ]
          );
        };
      })

      (lib.mkIf cfg.package {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              use-package
            ]
          );
        };
      })

      (lib.mkIf cfg.shell {
        nixpkgs.config.packageOverrides = pkgs: rec {
          myEmacs = pkgs.emacs.pkgs.withPackages (
            epkgs: with epkgs; [
              eat
              eshell-z
              esh-autosuggest
              xterm-color
              exec-path-from-shell
              pcmpl-args
              eshell-syntax-highlighting
              eshell-toggle
            ]
          );
        };
      })
    ]
  );
}
