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

### Git-annex sync workflow quick start
This is a compilation of the documentation provided at
[https://git-annex.branchable.com/](https://git-annex.branchable.com/].

Creating a repository is very straightforward:
```shell
$ mkdir ~/annex
$ cd ~/annex
$ git init
$ git annex init
```

Like any other git repository, git-annex repositories have remotes.
Let's start by adding a USB drive as a remote:
```shell
$ sudo mount /media/usb
$ cd /media/usb
$ git clone ~/annex
$ cd annex
$ git annex init "portable USB drive"
$ git remote add laptop ~/annex
$ cd ~/annex
$ git remote add usbdrive /media/usb/annex
```

It can also be used with a git remote that is truly remote, a host accessed by
ssh:
```shell
$local: git clone <user@hostname>:/home/me/annex ~/annex
$local: cd ~/annex
$local: git annex init "my desktop"
```
or the other way:
```shell
# SSH to remote machine
$remote: mkdir ~/annex
$remote: cd ~/annex
$remote: git init
$remote: git annex init "my remote"
# Switch back to local machine
$local: git remote add <remote> <user@hostname>:/home/me/annex
$local: git push -u <remote> <branch>
```

Merge synced/$currentbranch, pull changes from specified remote and update
synced/$currentbranch:
```shell
$ cd </path/to/annex>
git annex sync --content
```
This has to be done in all repositories in a decentralized fashion.
To avoid errors caused on repositories without access privileges to remotes,
only merge the synced changes:
```shell
$remote: git annex merge
```

Configure the settings of git-annex repositories:
```shell
Require multiple copies of files on accessible remotes
git annex numcopies 2
# Exclude specific files in the preferred content section
git annex wanted here "exclude=*.flac"
# Alternatively edit the configuration file directly
git annex vicfg
```

Remove an obsolete remote repository:
```shell
git annex move --from <remote>
git annex dead <remote>
git remote rm <remote>
```

## Known issues
- Attribute sets in custom config are not used for build outputs in flake.nix
- Wireguard configuration is only a dummy implementation without actual keys
- Disko module import not working in default.nix
- Encrypted drives need key files to unlock in the disko virtual machine

## Acknowledgment
Inspirations came from various sources.
Some valueable resources are:

[tweag](https://github.com/tweag/nix-hour)

[systemcrafters](https://systemcrafters.net/)

[tfc](https://github.com/tfc/nixos-configs)

[srid](https://github.com/srid/nixos-unified)

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
