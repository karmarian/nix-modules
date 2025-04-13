# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.printing = {
    enable = lib.mkEnableOption "Printer and CUPS";
  };

  config = lib.mkIf config.mine.module.system.printing.enable {
    environment.systemPackages = with pkgs; [
      hplip
      stable.xsane
    ];

    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;
        # Disable browsed for security reasons (cups vulnerability)
        browsed.enable = false;
      };
    };
  };
}
