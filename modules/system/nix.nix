# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.nix;

in
{
  options.mine.module.system.nix = {
    enable = lib.mkEnableOption "Nix config";
    store-optimisation.enable = lib.mkEnableOption "Store optimisation";
    auto-upgrade.enable = lib.mkEnableOption "Automatic system upgrade";
  };

  config = lib.mkIf cfg.enable (
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

      (lib.mkIf cfg.store-optimisation.enable {
        nix = {
          # Store optimization on every build.
          settings.auto-optimise-store = true;

          # Automatic scheduled garbage collection.
          gc = {
            automatic = true;
            dates = "monthly";
            options = "--delete-older-than 30d";
          };

          # Automatic scheduled store optimisation.
          optimise = {
            automatic = true;
            dates = [ "20:15" ];
          };
        };
      })

      (lib.mkIf cfg.auto-upgrade.enable {
        system.autoUpgrade = {
          enable = true;
          flake = inputs.self.outPath;
          flags = [
            "--update-input"
            "home-manager"
            "musnix"
            "nixpkgs"
            "nixpkgs-unstable"
            "-L"
          ];
          dates = "19:00";
          randomizedDelaySec = "45min";
        };
      })
    ]
  );
}
