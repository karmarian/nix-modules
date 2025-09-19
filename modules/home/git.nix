# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.git;

in
{
  options.mine.module.home.git = {
    enable = lib.mkEnableOption "Git apps and config";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "me@posteo.org";
      description = "Username config";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "me";
      description = "Email config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git-annex
      git-lfs
    ];

    programs.git = {
      enable = lib.mkDefault true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      lfs.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      extraConfig = {
        credential.helper = lib.mkDefault "store";
        init.defaultBranch = lib.mkDefault "main";
        push.autoSetupRemote = lib.mkDefault true;
      };
      aliases = {
        pushfwl = lib.mkDefault "push --force-with-lease";
        co = lib.mkDefault "checkout";
        cp = lib.mkDefault "cherry-pick";
      };
    };

    programs.lazygit.enable = lib.mkDefault false;
  };
}
