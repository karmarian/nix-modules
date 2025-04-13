# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.virtualization = {
    enable = lib.mkEnableOption "Virtualization apps";
  };

  config = lib.mkIf config.mine.module.system.virtualization.enable {
    boot.binfmt.emulatedSystems = lib.mkDefault [
      "aarch64-linux"
      "armv7l-linux"
    ];
    nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

    boot.extraModprobeConfig = lib.mkDefault "options kvm-intel nested=Y";

    # User for testing in VM with build-vm.
    users.users.nixosvmtest.isSystemUser = lib.mkDefault true;
    users.users.nixosvmtest.initialPassword = lib.mkDefault "test";
    users.users.nixosvmtest.group = lib.mkDefault "nixosvmtest";
    users.groups.nixosvmtest = lib.mkDefault { };

    environment.systemPackages = with pkgs; [
      libvirt
      virt-manager
      gnome-boxes
      neon
      qemu
      spice
      spice-gtk
      spice-vdagent
      webdav-server-rs
    ];

    virtualisation = {
      vmVariant = {
        # Following configuration is added only when building VM with build-vm.
        virtualisation = {
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
      };

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

      # Install and enable libvirt daemon.
      libvirtd.enable = lib.mkDefault true;

      # Enable WayDroid LXC container to run Android apps.
      # Waydroid has to be initialized once using 'waydroid init' and the
      # *waydroid-container* has to be started using systemd.
      waydroid.enable = lib.mkDefault true;
    };
  };
}
