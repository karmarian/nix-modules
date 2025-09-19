# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.tmux;

in
{
  options.mine.module.home.tmux = {
    enable = lib.mkEnableOption "Tmux application and configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        xsel # for tmux-yank
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        reattach-to-user-namespace # sensible
      ];

    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 200;
      historyLimit = 5000;
      keyMode = "vi";
      newSession = true;
      sensibleOnTop = true;
      shortcut = "a";
      terminal = "tmux-direct";
      extraConfig = ''
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
