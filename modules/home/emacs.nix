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
  };

  config = lib.mkIf config.mine.module.home.emacs.enable {
    home.packages = with pkgs; [
      # Emacs package dependencies
      clang-tools
      cmake
      direnv
      ghostscript
      git
      git-annex
      global
      guile
      source-code-pro
      universal-ctags
    ];

    programs.emacs = {
      enable = lib.mkDefault true;
      extraPackages =
        epkgs: with epkgs; [
          # Emacs editor package
          build-farm
          guix
          nix-mode
          use-package

          auctex
          apheleia
          clang-format
          cmake-font-lock
          cmake-ide
          cmake-mode
          cmake-project
          company
          daemons
          direnv
          docker
          dockerfile-mode
          dts-mode
          eglot
          ement
          emms
          elpy

          # Emacs eshell packages
          eat
          eshell-z
          esh-autosuggest
          xterm-color
          exec-path-from-shell
          pcmpl-args
          eshell-syntax-highlighting
          eshell-toggle
          vterm

          # Emacs evil packages
          evil
          evil-collection
          evil-org

          exec-path-from-shell
          flycheck
          geiser
          geiser-guile
          ggtags
          git-link
          hydra
          iedit
          lispy
          lispyville

          # Emacs magit packages
          magit
          magit-annex
          magit-todos

          markdown-mode
          multiple-cursors
          org
          org-roam
          projectile
          rainbow-delimiters
          rainbow-mode
          rust-mode
          smartparens
          sly
          sly-asdf
          undo-tree
          vertico
          visual-fill-column
          yaml
          yasnippet
          yasnippet-snippets
        ];
    };

    services.emacs = {
      enable = lib.mkDefault true;
      extraOptions = lib.mkDefault [ "--daemon" ];
      client = {
        enable = lib.mkDefault true;
        arguments = lib.mkDefault [ "-c" ];
      };
      socketActivation.enable = lib.mkDefault true;
      startWithUserSession = lib.mkDefault true;
      defaultEditor = lib.mkDefault false;
    };
  };
}
