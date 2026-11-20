# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  description = "NixOS Configuration with Flakes";

  inputs = {
    # Official NixOS package source, using unstable and stable branches.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Home-manager source, used for managing user configurations.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Disko source, used for declarative disk partitioning.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Musnix source for music production using Nix.
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixOS WSL sources.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-manager = {
      url = "github:karmarian/wrapper-manager";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixos-hardware,
      disko,
      musnix,
      nixos-wsl,
      wrapper-manager,
      ...
    }:

    let
      # :TODO: Import and inherit attributes from peronal config module.
      userVm = "me";
      machineVm = "vm";
      machineWsl = "wsl";
      defaultSystem = "x86_64-linux";

      overlays = [
        (final: prev: {
          stable = import nixpkgs-stable {
            inherit (final.stdenv.hostPlatform) system;
            config = import ./nixpkgs/config.nix;
          };
        })
        (import ./overlays/default.nix)
        (
          final: prev:
          let
            wm-eval = wrapper-manager.lib {
              pkgs = final;
              modules = [
                ./packages/wrapper-manager/default.nix
              ];
            };
          in
          {
            wrapped = nixpkgs.lib.mapAttrs (name: wrapper: wrapper.wrapped) wm-eval.config.wrappers;
          }
        )
      ];

      pkgs = import nixpkgs {
        system = defaultSystem;
        overlays = overlays;
        config = { };
      };

    in
    {
      nixosConfigurations = {
        # Run the following command in the flake's directory to deploy this
        # configuration on any NixOS system:
        # sudo nixos-rebuild switch --flake .#vm
        ${machineVm} = nixpkgs.lib.nixosSystem {

          # Pass flake inputs into all sub modules of NixOS config.
          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs = {
                overlays = overlays;
                config = { };
              };
            }
            # Use personal configuration settings.
            ./modules/personal/config.nix
            ./systems/vm/configuration.nix
            disko.nixosModules.disko
            musnix.nixosModules.musnix
          ];
        };

        ${machineWsl} = nixpkgs.lib.nixosSystem {

          specialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs = {
                overlays = overlays;
                config = { };
              };
            }
            ./modules/personal/config.nix
            ./systems/${machineWsl}/configuration.nix
            nixos-wsl.nixosModules.wsl
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users = {
                ${userVm} = import ./homes/${userVm}/home.nix;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        ${userVm} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./modules/personal/config.nix
            ./homes/${userVm}/home.nix
          ];
        };
      };

      packages.${defaultSystem} = {
        test-image = import ./qemu.nix { pkgs = pkgs; };
      };

      devShells."${defaultSystem}".default = pkgs.mkShell {
        packages = with pkgs; [
          npins
          reuse
        ];
      };
    };
}
