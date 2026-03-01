# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.home.container;

in
{
  options.mine.module.home.container = {
    enable = lib.mkEnableOption "Container apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dive # look into docker image layers
      flatpak
      guix
      podman-compose # start group of containers for dev
      qemu
    ];

    programs.distrobox = {
      enable = lib.mkDefault true;
      enableSystemdUnit = lib.mkDefault true;
      settings = {
        container_always_pull = lib.mkDefault "1";
        container_generate_entry = lib.mkDefault 0;
        container_manager = lib.mkDefault "podman";
        container_image_default = lib.mkDefault "docker.io/library/debian:unstable";
        container_name_default = lib.mkDefault "debian-unstable";
        container_user_custom_home = lib.mkDefault "$HOME/.local/share/distrobox/default";
        non_interactive = lib.mkDefault "0";
        skip_workdir = lib.mkDefault "0";
      };
      containers = {
        alpine-edge = {
          additional_packages = "direnv git git-annex git-lfs vim tmux";
          home = "$HOME/.local/share/distrobox/alpine-edge";
          image = "docker.io/library/alpine:edge";
          init = false;
          nvidia = false;
          pull = true;
          root = false;
          entry = true;
          replace = true;
          start_now = false;
        };
        debian-unstable = {
          additional_packages = "direnv git git-annex git-lfs vim tmux";
          home = "$HOME/.local/share/distrobox/debian-unstable";
          image = "docker.io/library/debian:unstable";
          init = false;
          nvidia = false;
          pull = true;
          root = false;
          entry = true;
          replace = true;
          start_now = false;
        };
      };
    };

    services.podman = {
      enable = lib.mkDefault true;
      settings = {
        registries.search = lib.mkDefault [
          "registry.access.redhat.com"
          "registry.redhat.io"
          "docker.io"
        ];
        policy = {
          default = [ { type = "reject"; } ];
          transports = {
            docker = {
              "docker.io" = [ { type = "insecureAcceptAnything"; } ];
            };
          };
        };
      };
    };
  };
}
