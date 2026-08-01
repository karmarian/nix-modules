# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.desktop;

in
{
  options.mine.module.system.desktop = {
    enable = lib.mkEnableOption "Desktop apps and browser settings";
    browser.enable = lib.mkEnableOption "Browsers";
    browser.privacy.enable = lib.mkEnableOption "Extra privacy focused browsers";
    utils.enable = lib.mkEnableOption "Desktop utilities";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.browser.enable {
        programs.firefox = {
          enable = true;

          # System-wide policies that go to /etc/firefox/policies/policies.json.
          policies = {
            Preferences = {
              "browser.sessionstore.interval" = 60000;
              "browser.tabs.animate" = false;
              "browser.download.animateNotifications" = false;
              "browser.urlbar.maxRichResults" = 5;
              "dom.battery.enabled" = false;
              "extensions.pocket.enabled" = false;
              "general.smoothScroll" = false;
              "network.prefetch-next" = false;
              "privacy.trackingprotection.enabled" = true;
              "toolkit.cosmeticAnimations.enabled" = false;

              # Performance settings
              "layout.frame_rate.precise" = true;
              "webgl.force-enabled" = true;
              "layers.acceleration.force-enabled" = true;
              "layers.offmainthreadcomposition.enabled" = true;
              "layers.offmainthreadcomposition.async-animations" = true;
              "layers.async-video.enabled" = true;
              "html5.offmainthread" = true;
            };

            # Prevent Firefox from updating itself.
            DisableAppUpdate = true;
          };
        };

        environment.systemPackages = with pkgs; [
          brave
        ];
      })

      (lib.mkIf cfg.browser.privacy.enable {
        environment.systemPackages = with pkgs; [
          mullvad-browser
        ];
      })

      (lib.mkIf cfg.utils.enable {
        environment.systemPackages = with pkgs; [
          bustle
          kdePackages.okular
          keepassxc
          pika-backup
          thunderbird
          tutanota-desktop
          warp
        ];
      })
    ]
  );
}
