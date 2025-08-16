# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

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

  config = lib.mkIf config.mine.module.home.emacs.enable (
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
          defaultEditor = lib.mkDefault true;
        };
      }

      (lib.mkIf config.mine.module.home.emacs.comms {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            ement
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.core {
        home.packages = with pkgs; [
          source-code-pro
        ];

        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            clipetty
            vertico
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.dev {
        home.packages = with pkgs; [
          clang-tools
          cmake
          direnv
          ghostscript
          git
          git-annex
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
            flycheck
            geiser
            geiser-guile
            git-link
            ggtags
            guix
            hydra
            iedit
            lispy
            lispyville
            magit
            magit-annex
            magit-todos
            markdown-mode
            multiple-cursors
            nix-mode
            projectile
            rainbow-delimiters
            rainbow-mode
            rust-mode
            smartparens
            sly
            sly-asdf
            undo-tree
            visual-fill-column
            yaml
            yasnippet
            yasnippet-snippets
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.evil {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            evil
            evil-collection
            evil-org
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.music {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            emms
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.org {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            org
            org-roam
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.package {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            use-package
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.python {
        programs.emacs.extraPackages =
          epkgs: with epkgs; [
            elpy
          ];
      })

      (lib.mkIf config.mine.module.home.emacs.shell {
        programs.emacs.extraPackages =
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
      })
    ]
  );
}
