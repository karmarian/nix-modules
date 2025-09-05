# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import sources.nixos-stable {
    config = { };
    overlays = [ ];
    inherit system;
  };
  pkgs-unstable = import sources.nixpkgs-unstable {
    config = { };
    overlays = [ ];
    inherit system;
  };
  home-manager = (import sources.home-manager { }).path;
  disko = import sources.disko { };
  overlay-unstable = final: prev: {
    unstable = pkgs-unstable;
  };
  inherit (pkgs) lib;
in
lib.makeScope pkgs.newScope (final: {

  nixosSystem = import (sources.nixos-stable + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      ./systems/vm/configuration.nix
      (import "${home-manager}/nixos")
      (import "${disko}/module.nix")
      ./modules/personal/config.nix
      (
        { config, pkgs, ... }:
        {
          nixpkgs.overlays = [ overlay-unstable ];
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
