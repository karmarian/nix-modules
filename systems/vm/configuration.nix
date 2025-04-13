# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (config.mine.userVm) username;
  inherit (config.mine.userVm) uid;
  inherit (config.mine.machineVm)
    cores
    memorySize
    xkbLayout
    xkbVariant
    timeZone
    ;

in
{
  imports = [
    ../../modules/system
  ];

  # Declarative users
  users.mutableUsers = false;

  users.users.${username} = {
    # Configure a normal default user
    isNormalUser = true;
    # Set this to match your users uid (run `id`)
    # Makes the files in this directory editable within the VM without sudo
    uid = uid;
    # No password
    hashedPassword = "";
    # Add the default user to the wheel group, and make wheel more privileged
    extraGroups = [ "wheel" ];
  };

  # :KLUDGE: Until home-manager attribute sets are working in default.nix, this is placed here instead of
  # flake.nix and default.nix.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.${username} = import ../../homes/${username}/home.nix;

  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Set this to your timezone (run `tzselect`)
  time.timeZone = "${timeZone}";

  # Avoid the stateVersion warning.
  # Setting this to system.nixos.release is fine because we have no state
  system.stateVersion = config.system.nixos.release;

  # Auto-login the default user on consoles
  services.getty.autologinUser = "${username}";

  # Use the same keyboard layout in consoles as in the desktop
  console.useXkbConfig = true;

  # Programs are added with modules per system or per home.
  # programs = { };

  environment.systemPackages = with pkgs; [
    vm-switch
  ];

  # xserver, but actually really wayland
  services.xserver = {
    displayManager.gdm.autoSuspend = false;
    # Set this to your own layout (run `setxkbmap -query`)
    xkb = {
      layout = "${xkbLayout}";
      variant = "${xkbVariant}";
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "${username}";
  };

  # Set some dconf options declaratively
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

  virtualisation.vmVariant.virtualisation = {
    # Set this to a portion of your host machine's resources
    cores = lib.mkForce cores;
    memorySize = lib.mkForce memorySize;
  };

  # NixOS system gets customized by system modules, which are enabled here.
  mine.module.system.all.enable = true;
}
