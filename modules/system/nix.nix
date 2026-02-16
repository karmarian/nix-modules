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
            "pipe-operators"
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
          settings.auto-optimise-store = lib.mkDefault true;

          # Automatic scheduled garbage collection.
          gc = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault "monthly";
            options = lib.mkDefault "--delete-older-than 30d";
          };

          # Automatic scheduled store optimisation.
          optimise = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault [ "20:15" ];
          };
        };
      })

      (lib.mkIf cfg.auto-upgrade.enable {
        system.autoUpgrade = {
          enable = lib.mkDefault true;
          flake = lib.mkDefault inputs.self.outPath;
          flags = lib.mkDefault [
            "--update-input"
            "home-manager"
            "musnix"
            "nixpkgs"
            "nixpkgs-unstable"
            "-L"
          ];
          dates = lib.mkDefault "19:00";
          randomizedDelaySec = lib.mkDefault "45min";
        };
      })
    ]
  );
}
