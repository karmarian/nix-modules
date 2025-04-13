# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  collectOld = pkgs.writeScriptBin "nix-collect-old" ''
    nix-env --delete-generations old
    nix-collect-garbage
    nix-collect-garbage -d
    nix-store --gc --print-dead
    nix-store --optimize
  '';
in
{
  options.mine.module.home.shell-utils = {
    enable = lib.mkEnableOption "Shell utilities";
  };

  config = lib.mkIf config.mine.module.home.shell-utils.enable {
    home.packages = with pkgs; [
      dmidecode
      file
      gnupg
      gtop
      hwinfo
      lshw
      lsscsi
      magic-wormhole
      pciutils
      pstree
      rsync
      snapper
      tldr
      unzip
      usbutils
      zip
    ];

    programs = {
      autojump = {
        enable = true;
        enableBashIntegration = true;
      };
      command-not-found.enable = true;
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
      dircolors = {
        enable = true;
        enableBashIntegration = true;
      };
      htop = {
        enable = true;
        settings =
          {
            color_scheme = 6;
            cpu_count_from_zero = true;
            highlight_base_name = true;
            highlight_megabytes = true;
            highlight_threads = true;
          }
          // (
            with config.lib.htop;
            leftMeters [
              (bar "AllCPUs2")
              (bar "Memory")
              (bar "Swap")
              (bar "Battery")
            ]
          )
          // (
            with config.lib.htop;
            rightMeters [
              (text "Tasks")
              (text "LoadAverage")
              (text "Uptime")
              (text "CPU")
            ]
          );
      };
      man.enable = true;
    };
  };
}
