# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.printing;

in
{
  options.mine.module.system.printing = {
    enable = lib.mkEnableOption "Printer and CUPS";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hplip
      xsane
    ];

    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = lib.mkDefault true;
        # Disable browsed for security reasons (cups vulnerability)
        browsed.enable = lib.mkDefault false;
      };
    };
  };
}
