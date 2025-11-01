# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}:

let
  inherit (config.mine.userSubmodule.userVm)
    extraGroups
    isNormalUser
    username
    uid
    ;
  inherit (config.mine.machineSubmodule.machineVm)
    cores
    defaultLocale
    extraLocale
    hostname
    memorySize
    timeZone
    xkbLayout
    xkbVariant
    ;
  inherit (config.mine.peripheralSubmodule.peripheralVm)
    syncDevice
    syncDeviceId
    ;

in
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./disko-config.nix
    ../../modules/system
    ../../modules/musnix
  ];

  networking.hostName = "${hostname}"; # Define your hostname.

  # Optional. Useful for testing.
  # users.users.root.initialPassword = "root";

  # Declarative users.
  users.mutableUsers = false;

  users.users.${username} = {
    # Configure a normal default user.
    isNormalUser = isNormalUser;
    # Set this to match your users uid (run `id`).
    # Makes the files in this directory editable within the VM without sudo.
    uid = uid;
    # No password.
    hashedPassword = "";
    # Add the user to the extra group to get more privileges.
    extraGroups = extraGroups;
  };

  # :KLUDGE: Until home-manager attribute sets are working in default.nix, this
  # is placed here instead of flake.nix and default.nix.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.${username} = import ../../homes/${username}/home.nix;

  security.sudo.wheelNeedsPassword = false;

  # Programs are added with modules per system or per home.
  # Set some dconf options declaratively.
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = with lib.gvariant; {
          "org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
          };
        };
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vm-switch
  ];

  # NixOS system gets customized by system modules, which are enabled here.
  mine.module.system = {
    boot.enable = true;
    gnome = {
      enable = false;
      autoLogin.enable = true;
      autoLogin.user = username;
      xkbLayout = xkbLayout;
      xkbVariant = xkbVariant;
    };
    jellyfin = {
      enable = true;
      userName = username;
    };
    locale = {
      enable = true;
      defaultLocale = defaultLocale;
      extraLocale = extraLocale;
      timeZone = timeZone;
      keyboardLayout = xkbLayout;
    };
    mobile.enable = true;
    network = {
      enable = true;
      # VPN profile is not generic and correct settings have to applied.
      wireguard.enable = false;
    };
    nix = {
      enable = true;
      store-optimisation.enable = true;
      auto-upgrade.enable = true;
    };
    pipewire.enable = true;
    printing.enable = false;
    shell = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = username;
    };
    syncthing = {
      enable = false;
      userName = username;
      syncDevice = syncDevice;
      syncDeviceId = syncDeviceId;
    };
    unfree.enable = true;
    virtualisation = {
      enable = true;
      binfmt.enable = false;
      container.enable = false;
      variant.enable = true;
      vmCores = (cores / 2);
      vmMemorySize = (memorySize / 2);
      waydroid.enable = false;
      waydroid.autostart = false;
    };
    zram.enable = true;
  };
  mine.module.musnix.enable = true;

  # Avoid the stateVersion warning.
  # Setting this to system.nixos.release is fine because we have no state.
  system.stateVersion = config.system.nixos.release;

  # Adjust this to your liking.
  # WARNING: if you set a too low value the image might be not big enough to contain the nixos installation
  disko.devices.disk.main.imageSize = "30G";
}
