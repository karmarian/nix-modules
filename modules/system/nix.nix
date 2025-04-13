# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.nix = {
    enable = lib.mkEnableOption "Nix config";
  };

  config = lib.mkIf config.mine.module.system.nix.enable {
    # Set Nixpkgs overlays and config
    nixpkgs = {
      overlays = import ../../nixpkgs/overlays.nix;
      config = import ../../nixpkgs/config.nix;
    };

    # Enable experimental support like flakes.
    nix.settings = {
      experimental-features = lib.mkDefault [
        "nix-command"
        "flakes"
      ];
      trusted-users = lib.mkDefault [
        "root"
        "@wheel"
      ];
    };

    environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
  };
}
