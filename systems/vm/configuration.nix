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
    extraLocaleSet
    hostname
    memorySize
    scheme
    timeZone
    xkbLayout
    xkbVariant
    ;

in
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./disko-config.nix
    ../../modules/system
    ../../modules/musnix
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  networking.hostName = "${hostname}"; # Define your hostname.

  # Optional. Useful for testing.
  # users.users.root.initialPassword = "root";

  # Declarative users.
  # SECURITY: TEST-VM ONLY — passwordless sudo and empty user password are
  # deliberate test conveniences. DO NOT copy this pattern to a real host.
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
    default.scheme = scheme;
    audiobookshelf = {
      userName = "audiobookshelf";
    };
    gnome = {
      autoLogin.user = username;
      xkbLayout = xkbLayout;
      xkbVariant = xkbVariant;
    };
    immich = {
      userName = "immich";
    };
    jellyfin = {
      userName = "jellyfin";
      groupName = "jellyfin";
    };
    locale = {
      defaultLocale = defaultLocale;
      extraLocaleSet = extraLocaleSet;
      timeZone = timeZone;
      keyboardLayout = xkbLayout;
    };
    media = {
      mpd = {
        username = username;
        musicSubdir = "music";
      };
    };
    mobile = {
      userName = username;
    };
    network = {
      userName = username;
    };
    nix = {
      auto-upgrade.path = /etc/nixos;
    };
    remote-desktop.weylus.users = [ username ];
    shell = {
      autoLogin.user = username;
    };
    ssh = {
      server = {
        allowUsers = [ username ];
        ports = [ 22 ];
        permitRootLogin = "no";
        passwordAuthentication = false;
      };
    };
    sway = {
      userName = username;
    };
    virtualisation = {
      userName = username;
      vmCores = (cores / 2);
      vmMemorySize = (memorySize / 2);
    };
  };

  mine.module.musnix = lib.mkIf (scheme == "music") {
    enable = true;
  };

  mine.module.system.nix.lix.enable = lib.mkForce false;
  # Avoid the stateVersion warning.
  # Setting this to system.nixos.release is fine because we have no state.
  system.stateVersion = config.system.nixos.release;

  # Adjust this to your liking.
  # WARNING: if you set a too low value the image might be not big enough to contain the nixos installation
  disko.devices.disk.main.imageSize = "30G";
}
