# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation apps";
    binfmt.enable = lib.mkEnableOption "Emulation";
    container.enable = lib.mkEnableOption "Container";
    variant.enable = lib.mkEnableOption "Vm Variant";
    waydroid.enable = lib.mkEnableOption "Waydroid container";
    waydroid.autostart = lib.mkEnableOption "Autostart Waydroid service";
  };

  config = lib.mkIf config.mine.module.system.virtualisation.enable (
    lib.mkMerge [
      {
        boot.extraModprobeConfig = lib.mkDefault "options kvm-intel nested=Y";
        environment.systemPackages = with pkgs; [
          libvirt
          virt-manager
          neon
          qemu
          spice
          spice-gtk
          spice-vdagent
          webdav-server-rs
        ];

        # Install and enable libvirt daemon.
        virtualisation.libvirtd.enable = lib.mkDefault true;
      }

      (lib.mkIf config.mine.module.system.virtualisation.binfmt.enable {
        boot.binfmt.emulatedSystems = lib.mkDefault [
          "aarch64-linux"
          "armv7l-linux"
        ];
        nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
      })

      (lib.mkIf config.mine.module.system.virtualisation.variant.enable {
        # User for testing in VM with build-vm.
        users.users.nixosvmtest.isSystemUser = lib.mkDefault true;
        users.users.nixosvmtest.initialPassword = lib.mkDefault "test";
        users.users.nixosvmtest.group = lib.mkDefault "nixosvmtest";
        users.groups.nixosvmtest = lib.mkDefault { };

        virtualisation.vmVariant.virtualisation = {
          # Following configuration is added only when building VM with build-vm.
          memorySize = lib.mkDefault 4096; # Use 4096 MiB memory.
          cores = lib.mkDefault 2;
          # Make the screen size auto-scale
          qemu.options = lib.mkDefault [ "-vga virtio" ];

          # Don't persist any state, also allows Ctrl-C without problems
          diskImage = lib.mkDefault null; # "./nixos.qcow2";

          # Except the current directory, which is shared in /etc/nixos
          sharedDirectories.share = {
            source = lib.mkDefault (toString ./.);
            target = lib.mkDefault "/etc/nixos";
          };

          # Allows Nix commands to re-use and write to the host's store
          mountHostNixStore = lib.mkDefault true;
          writableStoreUseTmpfs = lib.mkDefault false;
        };
        virtualisation.vmVariantWithDisko.virtualisation = {
          # Following configuration is added only when building VM with build-vm.
          memorySize = lib.mkDefault 4096; # Use 4096 MiB memory.
          cores = lib.mkDefault 2;
          # Make the screen size auto-scale
          qemu.options = lib.mkDefault [ "-vga virtio" ];

          # Don't persist any state, also allows Ctrl-C without problems
          diskImage = lib.mkDefault null; # "./nixos.qcow2";

          # Except the current directory, which is shared in /etc/nixos
          sharedDirectories.share = {
            source = lib.mkDefault (toString ./.);
            target = lib.mkDefault "/etc/nixos";
          };

          # Allows Nix commands to re-use and write to the host's store
          mountHostNixStore = lib.mkDefault true;
          writableStoreUseTmpfs = lib.mkDefault false;
        };
      })

      (lib.mkIf config.mine.module.system.virtualisation.container.enable {
        virtualisation = {
          # Enable common container config files in /etc/containers.
          containers.enable = lib.mkDefault true;
          # Install and configure Podman.
          podman = {
            enable = lib.mkDefault true;
            # Create a `docker` alias for podman, to use it as a drop-in replacement.
            dockerCompat = lib.mkDefault true;
            # Required for containers under podman-compose to be able to talk to each other.
            defaultNetwork.settings.dns_enabled = lib.mkDefault true;
          };
        };
      })

      (lib.mkIf config.mine.module.system.virtualisation.waydroid.enable {
        # Enable WayDroid LXC container to run Android apps.
        # Waydroid has to be initialized once using 'waydroid init' and the
        # *waydroid-container* has to be started using systemd.
        virtualisation.waydroid.enable = lib.mkDefault true;

        # Disable Waydroid container service at startup.
        systemd.services.waydroid-container.wantedBy = lib.mkIf (
          !config.mine.module.system.virtualisation.waydroid.autostart
        ) (lib.mkForce [ ]);
      })
    ]
  );
}
