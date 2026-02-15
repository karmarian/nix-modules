# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  hardware,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.pipewire;

in
{
  options.mine.module.system.pipewire = {
    enable = lib.mkEnableOption "Pipewire config";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.qpwgraph
    ];
    services = {
      pulseaudio.enable = lib.mkDefault false;
      pipewire = {
        enable = lib.mkDefault true;
        alsa.enable = lib.mkDefault true;
        alsa.support32Bit = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
        # If you want to use JACK applications, uncomment this
        jack.enable = lib.mkDefault true;
      };
    };
    security.rtkit.enable = lib.mkDefault true;
  };
}
