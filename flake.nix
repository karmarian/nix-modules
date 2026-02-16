# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  description = "NixOS Configuration with Flakes";

  inputs = {
    # Official NixOS package source, using unstable and stable branches.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home-manager source, used for managing user configurations.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      nixpkgs-unstable,
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
      system = "x86_64-linux";

      stdenv.hostPlatform.system = system;
      pkgs = nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
      };

      wm-eval = wrapper-manager.lib {
        inherit pkgs;
        modules = [
          ./packages/wrapper-manager/default.nix
          {
            wrappers.hello = {
              basePackage = pkgs.hello;
              prependFlags = [
                "-g"
                "This is a tasty wrap"
              ];
            };
          }
        ];
      };

      # Extract all wrapped packages.
      allWrappers = wm-eval.config.build.packages;
      direnvWrapped = wm-eval.config.wrappers.direnv.wrapped;
      elementWrapped = wm-eval.config.wrappers.element.wrapped;
      gitWrapped = wm-eval.config.wrappers.git.wrapped;
      helloWrapped = wm-eval.config.wrappers.hello.wrapped;
      jamiWrapped = wm-eval.config.wrappers.jami.wrapped;
      keepassxcWrapped = wm-eval.config.wrappers.keepassxc.wrapped;
      singalWrapped = wm-eval.config.wrappers.signal.wrapped;
      teleportsWrapped = wm-eval.config.wrappers.teleports.wrapped;
      tmuxWrapped = wm-eval.config.wrappers.tmux.wrapped;
      torBrowserWrapped = wm-eval.config.wrappers.tor-browser.wrapped;
      vimWrapped = wm-eval.config.wrappers.vim.wrapped;

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

      packages.${stdenv.hostPlatform.system} = {
        # all = allWrappers;
        direnv = direnvWrapped;
        element = elementWrapped;
        git = gitWrapped;
        hello = helloWrapped;
        jami = jamiWrapped;
        keepassxc = keepassxcWrapped;
        signal = singalWrapped;
        teleports = teleportsWrapped;
        # Fix for build issue required.
        # tmux = tmuxWrapped;
        tor-browser = torBrowserWrapped;
        vim = vimWrapped;
      };

      devShells."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            npins
            reuse
          ];

          shellHook = ''
            echo "Entering devShell`"
          '';
        };
    };
}
