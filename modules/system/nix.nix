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

  lixOverlay =
    if cfg.lix.enable then
      [
        (final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ]
    else
      [ ];

in
{
  options.mine.module.system.nix = {
    enable = lib.mkEnableOption "Nix config";
    lix.enable = lib.mkEnableOption "Nix-like package manager";
    store-optimisation.enable = lib.mkEnableOption "Store optimisation";
    auto-upgrade = {
      enable = lib.mkEnableOption "Automatic system upgrade";
      method = lib.mkOption {
        type = lib.types.enum [
          "flake"
          "channels"
          "npins"
          "disabled"
        ];
        default = "disabled";
        description = "Method for automatic upgrades";
      };
      path = lib.mkOption {
        type = lib.types.path;
        default = /etc/nixos;
        example = "/home/user/nixos-config";
        description = "Path to project root directory";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # Set Nixpkgs overlays and config.
        nixpkgs = {
          overlays = (import ../../nixpkgs/overlays.nix) ++ lixOverlay;
          config = import ../../nixpkgs/config.nix;
        };

        nix = {
          channel.enable = false;
          nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          registry = {
            nixpkgs.flake = inputs.nixpkgs;
          };
          settings = {
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
        };

        environment.systemPackages =
          let
            # Creating a shell script omitting repl from nix.nixPath.
            repl_path = toString ./.;
            karmar-nix-fast-repl = pkgs.writeShellScriptBin "karmar-nix-fast-repl" ''
              source /etc/set-environment
              nix repl "${repl_path}/repl.nix" "$@"
            '';
          in
          [
            karmar-nix-fast-repl

            pkgs.nixfmt
          ];
      }

      (lib.mkIf cfg.lix.enable {
        nix.package = pkgs.lixPackageSets.stable.lix;
      })

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

      (lib.mkIf (cfg.auto-upgrade.enable && cfg.auto-upgrade.method == "flake") {
        system.autoUpgrade = {
          enable = lib.mkDefault true;
          flake = lib.mkDefault inputs.self.outPath;
          flags = lib.mkDefault [
            "--update-input"
            "home-manager"
            "--update-input"
            "musnix"
            "--update-input"
            "nixpkgs"
            "--update-input"
            "nixpkgs-unstable"
            "-L"
          ];
          dates = lib.mkDefault "19:00";
          randomizedDelaySec = lib.mkDefault "45min";
        };
      })
      (lib.mkIf (cfg.auto-upgrade.enable && cfg.auto-upgrade.method == "channels") {
        system.autoUpgrade = {
          enable = lib.mkDefault true;
          channel = lib.mkDefault "nixos";
          flags = lib.mkDefault [
            "--upgrade"
            "-L"
          ];
          dates = lib.mkDefault "19:00";
          randomizedDelaySec = lib.mkDefault "45min";
        };
      })
      (lib.mkIf (cfg.auto-upgrade.enable && cfg.auto-upgrade.method == "npins") {
        systemd.services.npins-auto-update = {
          description = "Automatic npins update and system rebuild";
          path = with pkgs; [
            npins
            nixos-rebuild
          ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "npins update" ''
              cd ${cfg.auto-upgrade.path}
              npins update
              nixos-rebuild switch --file default.nix
            '';
          };
        };
        systemd.timers.npins-auto-update = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = lib.mkDefault "19:00";
            RandomizedDelaySec = lib.mkDefault "45min";
          };
        };
      })
      (lib.mkIf (cfg.auto-upgrade.enable && cfg.auto-upgrade.method == "npins") {
        # No auto-upgrades.
      })
    ]
  );
}
