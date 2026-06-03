# SPDX-FileCopyrightText: Tweag I/O Limited
# SPDX-License-Identifier: LicenseRef-MIT-TWEAG-IO-LIMITED

{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import sources."nixos-26.05" {
    config = { };
    overlays = [
      unstableOverlay
      (import ./overlays/default.nix)
    ];
    inherit system;
  };

  home-manager = (import sources.home-manager { }).path;
  disko = import sources.disko { };
  musnix = import sources.musnix { };

  unstableOverlay = final: prev: {
    unstable = import sources.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = prev.config;
    };
  };

  inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (final: {

  nixosSystem = import (sources."nixos-26.05" + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      ./systems/vm/configuration.nix
      (import "${home-manager}/nixos")
      (import "${sources.disko.outPath}/module.nix")
      (import "${sources.musnix.outPath}")
      ./modules/personal/config.nix
      (
        { config, pkgs, ... }:
        {
          nixpkgs.overlays = [
            unstableOverlay
            (import ./overlays/default.nix)
          ];
        }
      )
    ];
    specialArgs = {
      inherit sources;
    };
  };

  vm =
    let
      build = final.nixosSystem.config.virtualisation.vmVariant.system.build;
    in
    {
      # A script to run the VM
      run = build.vm;
      # The VM's system itself, used by vm-switch
      system = build.toplevel;
    };

  shell = pkgs.mkShell {
    packages = [
      pkgs.npins
      pkgs.reuse
    ];
  };
})
