# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.vim;

in
{
  options.mine.module.home.vim = {
    enable = lib.mkEnableOption "Vim application and configuration";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = false;
      vimdiffAlias = true;
      withNodeJs = true;
      extraConfig = builtins.readFile ./vim/vimrc;
      plugins = with pkgs.vimPlugins; [
        telescope-nvim
        vim-colorschemes
        modus-themes-nvim
        vim-nix
        {
          plugin = vimtex;
          config = ''
            let g:vimtex_view_automatic = 0
            let g:vimtex_fold_enabled = v:true
            let  g:vimtex_fold_types = {
             \ 'envs' : {
             \   'blacklist' : [
             \     'block',
             \     'center',
             \     'item',
             \     'itemize',
             \     'lstlisting',
             \     'tabular',
             \     'varblock',
             \   ],
             \ },
             \}
             let g:vimtex_quickfix_ignore_filters = [
             \ 'Underfull',
             \ 'Overfull',
             \]
          '';
        }
        vim-tmux-navigator
        {
          plugin = bufexplorer;
          config = "nnoremap <silent> <F4> :ToggleBufExplorer<CR>";
        }
        {
          plugin = nerdtree;
          config = ''
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

            let g:NERDTreeDirArrows = 1
            let g:NERDTreeMinimalUI = 1
            let g:NERDTreeMouseMode = 2
            let g:NERDTreeQuitOnOpen = 1
            let g:NERDTreeWinSize = 60

            nnoremap <silent> <F3> :NERDTreeToggle<CR>
          '';
        }
        {
          plugin = vim-airline;
          config = ''
            set laststatus=2
          '';
        }
        {
          plugin = vim-better-whitespace;
          config = ''
            let g:better_whitespace_enabled = 1
            let g:strip_whitespace_on_save = 1
            let g:strip_whitespace_confirm = 0
            let g:strip_whitelines_at_eof = 1
            let g:show_spaces_that_precede_tabs = 1
            let g:better_whitespace_filetypes_blacklist = ['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive']
          '';
        }
      ];
    };

    home.packages = with pkgs; [
      bash-language-server
      ccls
      ltex-ls
      nixd
      nixfmt-rfc-style
    ];
  };
}
