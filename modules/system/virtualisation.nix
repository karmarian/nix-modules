# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.virtualisation;

in
{
  options.mine.module.system.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation apps";
    binfmt.enable = lib.mkEnableOption "Emulation";
    container.enable = lib.mkEnableOption "Container";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "libvirt";
      description = "User of libvirt";
    };
    variant.enable = lib.mkEnableOption "Vm Variant";
    vmCores = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Number of cores for virtual machine";
    };
    vmMemorySize = lib.mkOption {
      type = lib.types.int;
      default = 2048;
      description = "Amount of MebiBytes for virtual machine";
    };
    waydroid.enable = lib.mkEnableOption "Waydroid container";
    waydroid.autostart = lib.mkEnableOption "Autostart Waydroid service";
  };

  config = lib.mkIf cfg.enable (
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
        virtualisation.libvirtd = {
          enable = lib.mkDefault true;
          qemu = {
            package = lib.mkDefault pkgs.qemu_kvm;
            runAsRoot = lib.mkDefault true;
            swtpm.enable = lib.mkDefault true;
          };
        };

        users.users.${cfg.userName}.extraGroups = [
          "kvm"
          "libvirtd"
        ];
      }

      (lib.mkIf cfg.binfmt.enable {
        boot.binfmt.emulatedSystems = lib.mkDefault [
          "aarch64-linux"
          "armv7l-linux"
        ];
        nix.settings.extra-platforms = lib.mkDefault config.boot.binfmt.emulatedSystems;
      })

      (lib.mkIf cfg.variant.enable {
        # User for testing in VM with build-vm.
        users.users.nixosvmtest = {
          isNormalUser = lib.mkDefault true;
          initialPassword = lib.mkDefault "test";
          extraGroups = lib.mkDefault [
            "nixosvmtest"
            "wheel"
          ];
        };

        virtualisation.vmVariant.virtualisation = {
          # Following configuration is added only when building VM with build-vm.
          memorySize = cfg.vmMemorySize;
          cores = cfg.vmCores;
          # Make the screen size auto-scale
          qemu.options = lib.mkDefault [ "-vga virtio" ];

          # Don't persist any state, also allows Ctrl-C without problems
          diskImage = lib.mkDefault null; # "./nixos.qcow2";
        };
      })

      (lib.mkIf cfg.container.enable {
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

      (lib.mkIf cfg.waydroid.enable {
        # Enable WayDroid LXC container to run Android apps.
        # Waydroid has to be initialized once using 'waydroid init' and the
        # *waydroid-container* has to be started using systemd.
        virtualisation.waydroid.enable = lib.mkDefault true;

        # Disable Waydroid container service at startup.
        systemd.services.waydroid-container.wantedBy = lib.mkIf (!cfg.waydroid.autostart) (lib.mkForce [ ]);
      })
    ]
  );
}
