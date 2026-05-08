# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.programming;

in
{
  options.mine.module.home.programming = {
    enable = lib.mkEnableOption "Programming apps";
    python.enable = lib.mkEnableOption "Python environment tools";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          cachix
          cntr
          just
          mob
          nix-diff
          nix-output-monitor
          nix-top
          npins
          nvd
          stow
        ];

        programs.direnv = {
          enable = lib.mkDefault true;
          nix-direnv.enable = lib.mkDefault true;
        };
      }

      (lib.mkIf cfg.python.enable {
        home.packages = with pkgs; [
          # Python with development packages
          (python3.withPackages (p: [
            p.python
            p.black
            p.flake8
            p.jedi
            p.pygments
            p.python-lsp-server
          ]))
          virtualenv
        ];

        programs.poetry = {
          enable = lib.mkDefault true;
          settings = {
            virtualenvs.create = lib.mkDefault true;
            virtualenvs.in-project = lib.mkDefault true;
          };
        };
        programs.uv.enable = lib.mkDefault true;
        programs.pyenv = {
          enable = lib.mkDefault true;
          enableBashIntegration = lib.mkDefault true;
        };
        programs.pylint.enable = lib.mkDefault true;
      })
    ]
  );
}
