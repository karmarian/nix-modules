# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.ssh;

in
{
  options.mine.module.home.ssh = {
    enable = lib.mkEnableOption "SSH config";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = lib.mkDefault true;
      enableDefaultConfig = lib.mkDefault false;
      matchBlocks = {
        "*" = {
          forwardAgent = lib.mkDefault false;
          addKeysToAgent = lib.mkDefault "yes";
          compression = lib.mkDefault false;
          serverAliveInterval = lib.mkDefault 0;
          serverAliveCountMax = lib.mkDefault 3;
          hashKnownHosts = lib.mkDefault false;
          userKnownHostsFile = lib.mkDefault "~/.ssh/known_hosts";
          controlMaster = lib.mkDefault "no";
          controlPath = lib.mkDefault "~/.ssh/master-%r@%n:%p";
          controlPersist = lib.mkDefault "no";
        };
      }
      // import ./ssh/match-block.nix;
      extraConfig = import ./ssh/extra-config.nix;
    };

    services = {
      ssh-agent = {
        enable = lib.mkDefault true;
      };
    };
  };
}
