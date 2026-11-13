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

  # Collect all packages from enabled options
  emacsPackages =
    with pkgs.emacsPackages;
    lib.optionals cfg.core [
      clipetty
      vertico
      which-key
    ]
    ++ lib.optionals cfg.dev [
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
    ++ lib.optionals cfg.evil [
      evil
      evil-collection
      evil-org
    ]
    ++ lib.optionals cfg.music [
      emms
    ]
    ++ lib.optionals cfg.org [
      org-roam
    ]
    ++ lib.optionals cfg.package [
      use-package
    ]
    ++ lib.optionals cfg.shell [
      eat
      eshell-z
      esh-autosuggest
      xterm-color
      exec-path-from-shell
      pcmpl-args
      eshell-syntax-highlighting
      eshell-toggle
    ]
    ++ lib.optionals cfg.comms [
      ement
    ];

  myEmacs = pkgs.emacs.pkgs.withPackages (epkgs: emacsPackages);

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

  config = lib.mkIf cfg.enable {
    # Define myEmacs once at the top level
    nixpkgs.config.packageOverrides = pkgs: {
      inherit myEmacs;
    };

    environment.systemPackages =
      with pkgs;
      [
        myEmacs
        # Core dependencies
      ]
      ++ lib.optionals cfg.core [
        hunspell
        hunspellDicts.de-de
        hunspellDicts.en-us
        source-code-pro
      ]
      ++ lib.optionals cfg.dev [
        clang-tools
        cmake
        direnv
        ghostscript
        git
        global
        guile
        universal-ctags
      ];

    services.emacs = {
      enable = true;
      package = myEmacs;
    };
  };
}
