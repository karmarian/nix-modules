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
    environment.systemPackages = with pkgs; [
      coppwr
      easyeffects
      qpwgraph
    ];
    services = {
      pulseaudio.enable = lib.mkDefault false;
      pipewire = {
        enable = lib.mkDefault true;
        alsa.enable = lib.mkDefault true;
        alsa.support32Bit = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
        # `services.pipewire.jack.enable` is deprecated, because it introduces
        # global impurity via `LD_LIBRARY_PATH`. Use the `pw-jack` wrapper from
        # `pipewire.jack` where necessary instead.
        jack.enable = lib.mkDefault false;
      };
    };
    security.rtkit.enable = lib.mkDefault true;
  };
}
