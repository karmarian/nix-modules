# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  description = "NixOS Configuration with Flakes";

  inputs = {
    # Official NixOS package source, using unstable and stable branches.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home-manager source, used for managing user configurations.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      disko,
      musnix,
      nixos-wsl,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # :TODO: Import and inherit attributes from peronal config module.
      userVm = "me";
      machineVm = "vm";
      machineWsl = "wsl";

      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };

    in
    {
      nixosConfigurations = {
        # Run the following command in the flake's directory to deploy this
        # configuration on any NixOS system:
        # sudo nixos-rebuild switch --flake .#vm
        ${machineVm} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # Pass flake inputs into all sub modules of NixOS config.
          specialArgs = { inherit inputs; };

          modules = [
            # Use personal configuration settings.
            ./modules/personal/config.nix
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ./systems/vm/configuration.nix
            home-manager.nixosModules.home-manager
            # :KLUDGE: For compatibility with default.nix, this is placed into
            # the configuration.nix file.
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.backupFileExtension = "bak";
            #   home-manager.users = {
            #     ${userVm} = import ./homes/${userVm}/home.nix;
            #   };
            # }
            disko.nixosModules.disko
            musnix.nixosModules.musnix
          ];
        };

        ${machineWsl} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            ./modules/personal/config.nix
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
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
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ./homes/${userVm}/home.nix
          ];
        };
      };
    };
}
