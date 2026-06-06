# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.vim;

in
{
  options.mine.module.system.vim = {
    enable = lib.mkEnableOption "Vim application and configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = lib.mkDefault true;
      defaultEditor = lib.mkDefault true;
      vimAlias = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            telescope-nvim
            modus-themes-nvim
            vim-nix
            vim-tmux-navigator
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      bash-language-server
      ccls
      ltex-ls
      nixd
      nixfmt
    ];
  };
}
