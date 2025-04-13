# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.python = {
    enable = lib.mkEnableOption "Python apps";
  };

  config = lib.mkIf config.mine.module.home.python.enable {
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

    programs.poetry.enable = true;
    programs.pyenv.enable = true;
    programs.pylint.enable = true;
  };
}
