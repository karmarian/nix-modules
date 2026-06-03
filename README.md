SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>

SPDX-License-Identifier: CC-BY-SA-4.0

# Nix home and sytem modules

## Description
Provides Nix modules for Nix OS systems and home environments.
The modules can be tested in virtual machines pinned with Flake or npins.
Declares custom system configurations with attribute sets to fill personal
information using the Nix functional language.
Manages user home configurations using home-manager as Nix OS module with or
without Flakes.
Code and configs are work-in-progress and provided as-is with the main goal to
have a lot of fun.

## Usage

### Build and run the system in a virtual machine
Build the example virtual machine using the provided
[flake.nix](/flake.nix) output as virtual machine variant:
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
To start the virtual machine with the disko configuration run:
```shell
nix run -L '.#nixosConfigurations.vm.config.system.build.vmWithDisko'
```
Build a main.raw image file with the disko configuration for usage with qemu
scripts by executing:
```shell
nix build .#nixosConfigurations.vm.config.system.build.diskoImagesScript
sudo ./result --build-memory 2048
$(nix-build ./qemu.nix)/bin/test-image ./main.raw
```

The hardware parameters like used cores and RAM memory can be customized in the
file [config.nix](/modules/personnal/config.nix).

### Integrate the modules and modify personal settings
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

The file [config.nix](/modules/personal/config.nix) provides attribute sets for
user and machine information.
The corresponding customization file
[custom_config.nix](/modules/personal/custom_config.nix) can be used to
customize and configure systems conveniantly in a seperate file.
The prototypes for the attribute sets can be found in
[personal.nix](/modules/personal.nix).
The goal is to reduce the [flake.nix](/flake.nix), [default.nix](/default.nix),
[configuration.nix](/systems/vm/configuration.nix) and
[home.nix](/homes/me/home.nix) to the minimum generic code and fill all special
information in modules and configuration files, which can be reused more easily.
Hence, private information can be kept local in a seperate worktree or
repository.

### Deploy the configuration using Disko
The system configuration can be deployed with the manual Nix OS installer,
*nixos-anywhere* or as an image.
The official Nix OS installer is a simple way and also possible without Flakes.
There are several ways to transfer the files to the target system, where the
manual Nix OS installer is booted.

Prepare the Nix OS installer image as the SSH server:
```shell
$nixos-iso: sudo passwd nixos
$nixos-iso: ip addr
```
Prepare the local machine as the SSH client and clone the Git repository:
```shell
$local: ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_nixos
$local: ssh-copy-id -i ~/.ssh/id_ed25519_nixos nixos@<hostname>
$local: git bundle create nix-modules.bundle main
$local: scp nix-modules.bundle nixos@<ip-addr>:/tmp
cd /tmp
git clone nix-modules.bundle
```
Format the desired disk layout using disko:
```shell
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/nix-modules/systems/vm/disko-config.nix
# Optionally, generate the hardware configuration, if not already available
sudo -i nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix nix-modules/systems/vm
```
Install the custom Nix OS configuration and start the initial boot:
```shell
sudo -i nixos-install --flake '/tmp/nix-modules#vm'
nixos-enter --root /mnt -c 'passwd me'
reboot
```
Update the Nix OS configuration remotely using the openSSH server.
```shell
nixos-rebuild switch --use-remote-sudo --target-host <user>@<hostname> --flake .#odroid
```
Note that the user on the target system requires root privileges and has to be a
*trusted-user*.

### Wrapper-manager on Non-Nix OS systems
Wrappers don't interfere with the host system as home-manager does.
This might be the better way do bring applications especially to mobile phones
running GNU/Linux.
Clone the repository and run e.g.:
```shell
nix run .#vim
```
or load it directly from the GitLab server using:
```shell
nix run "gitlab:karmar-system/nix-modules?ref=develop#vim"
nix profile install "gitlab:karmar-system/nix-modules?ref=develop#vim"
```

Note: Wrapped packages are not yet in a usefull state.

## Known issues
- Non-flake is broken e.g. the Disko module import is not working in default.nix
- Attribute sets in custom config are not used for build outputs in flake.nix
- Wireguard configuration is only a dummy implementation without actual keys
- Encrypted drives need key files to unlock in the disko virtual machine
- Wrapped packages are not ready and broken

## Acknowledgment
Inspirations came from various sources.
Some valueable resources are:

[tweag](https://github.com/tweag/nix-hour)

[systemcrafters](https://systemcrafters.net/)

[tfc](https://github.com/tfc/nixos-configs)

[srid](https://github.com/srid/nixos-unified)

[ayats](https://ayats.org)

## Authors
**karmar@posteo.de**

## License
This repository uses the [REUSE software](https://reuse.software/) to provide
license information in a unambiguous and conveniant way.
Take a look at the header of the file of interest or in the folder
[LICENSES](/LICENSES/).
To check the REUSE compliance run:
```shell
nix-shell
reuse lint
```
