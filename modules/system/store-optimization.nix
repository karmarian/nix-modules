# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.system.store-optimization = {
    enable = lib.mkEnableOption "Nix storage optimization";
  };

  config = lib.mkIf config.mine.module.system.store-optimization.enable {
    # Automatic scheduled garbage collection.
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };

    # Automatic scheduled store optimization.
    nix.optimise.automatic = true;
    nix.optimise.dates = [ "20:15" ]; # Optional; allows customizing optimisation schedule

    # Store optimization on every build.
    nix.settings.auto-optimise-store = true;
  };
}
