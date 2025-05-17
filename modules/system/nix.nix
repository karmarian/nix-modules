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
    store-optimisation.enable = lib.mkEnableOption "Store optimisation";
  };

  config = lib.mkIf config.mine.module.system.nix.enable (
    lib.mkMerge [
      {
        # Set Nixpkgs overlays and config
        nixpkgs = {
          overlays = import ../../nixpkgs/overlays.nix;
          config = import ../../nixpkgs/config.nix;
        };

        nix.settings = {
          # Enable experimental support like flakes.
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
      }

      (lib.mkIf config.mine.module.system.nix.store-optimisation.enable {
        nix = {
          # Store optimization on every build.
          settings.auto-optimise-store = true;

          # Automatic scheduled garbage collection.
          gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 30d";
          };

          # Automatic scheduled store optimisation.
          optimise = {
            automatic = true;
            dates = [ "20:15" ];
          };
        };
      })
    ]
  );
}
