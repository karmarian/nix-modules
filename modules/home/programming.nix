# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.programming = {
    enable = lib.mkEnableOption "Programming apps";
    python.enable = lib.mkEnableOption "Python environment tools";
  };

  config = lib.mkIf config.mine.module.home.programming.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          cachix
          cntr
          mob
          nix-diff
          nix-output-monitor
          nix-top
          npins
          nvd
          stow
        ];

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      }

      (lib.mkIf config.mine.module.home.programming.python.enable {
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
          enable = true;
          settings = {
            virtualenvs.create = true;
            virtualenvs.in-project = true;
          };
        };
        programs.uv.enable = true;
        programs.pyenv = {
          enable = true;
          enableBashIntegration = true;
        };
        programs.pylint.enable = true;
      })
    ]
  );
}
