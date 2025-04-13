# Nix home and sytem modules

## Description
Provide Nix modules for Nix OS systems and home environments.
Modules can be tested in virtual machines supported as Flake or classic with
npins.
Declare custom system configurations with attribute sets to fill personal
information using the Nix functional language.
Manage user home configurations using home-manager as Nix OS module in the Flake
or without Flakes.

## Usage
Build the example virtual machine using the provided
[flake.nix](/flake.nix) output:
```shell
nixos-rebuild build-vm --flake .#vm
```
Launch the virtual machine following the given instructions with the
corresponding */nix/store* path.
As an alternative, the virtual machine can be build from the attribute declared
in the [default.nix](/default.nix) file.
```shell
# Build vm attribute
nix build -A vm.run
# Launch virtual machine
./result/bin/run-nixos-vm
```
It will auto-login into Gnome.
The hardware parameters like used cores and RAM memory can be customized in the
[virtualization.nix](/modules/system/virtualization.nix) module or in a custom
configuration in [config.nix](/config.nix).

The modules are split into [home](/modules/home) and [system](/modules/system)
to be included in the corresponding [home.nix](/homes/me/home.nix) or
[configuration.nix](/systems/vm/configuration.nix) files.
All modules can be enabled one-by-one or by activating all home or system
modules at once with:
```nix
mine.module.home.all.enable = true;
mine.module.system.all.enable = true;
```
as defined in e.g. [default.nix](/modules/home/default.nix).

The file [config.nix](/config.nix) provides attribute sets for user and machine
information, which can be used to customize and configure systems conveniantly
in a seperate file.
The prototypes for the attribute sets can be found in
[personal.nix](/modules/personal.nix).
The goal is to reduce the [flake.nix](/flake.nix), [default.nix](/default.nix),
[configuration.nix](/systems/vm/configuration.nix) and
[home.nix](/homes/me/home.nix) to the minimum generic code and fill all special
information in modules and configuration files, which can be reused easily.
Thereby, private information can be kept local in a seperate worktree or
repository.

## Known issues
- Attribute sets in custom config.nix are not used in modules
- Attribute sets in custom config.nix are not used for build outputs in flake.nix
- Standalone home-manager is not tracked by npins
- Wireguard configuration is only a dummy implementation without actual keys
- Musnix input is not activated, because it has to be added to default.nix

## License
SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
SPDX-License-Identifier: CC-BY-SA-4.0
