# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.shell-bash = {
    enable = lib.mkEnableOption "Shell bash config";
  };

  config = lib.mkIf config.mine.module.home.shell-bash.enable {
    home.packages = with pkgs; [
      bash-completion
      bashInteractive
    ];

    programs.bash = {
      enable = true;
      sessionVariables = {
        CLICOLOR = 1;
        COLORTERM = "truecolor";
        LSCOLORS = "GxFxCxDxBxegedabagaced";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        # Required for remote sudo authentication on target host.
        SSH_OPTS = "-tt";
      };
      shellAliases = import ./shell/shell-aliases.nix;
      profileExtra = ''
        eval "$(direnv hook bash)"
      '';
    };
  };
}
