# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mine.module.home.desktop = {
    enable = lib.mkEnableOption "Desktop apps and browser settings";
    comms.enable = lib.mkEnableOption "Communication apps";
  };

  config = lib.mkIf config.mine.module.home.desktop.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          kdePackages.okular
          tor-browser
        ];

        manual.html.enable = lib.mkDefault true;

        programs = {
          firefox = {
            enable = lib.mkDefault true;
            profiles = {
              myprofile = {
                settings = lib.mkDefault {
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

                  # performance suggestions from https://gist.github.com/0XDE57/fbd302cef7693e62c769
                  "layout.frame_rate.precise" = true;
                  "webgl.force-enabled" = true;
                  "layers.acceleration.force-enabled" = true;
                  "layers.offmainthreadcomposition.enabled" = true;
                  "layers.offmainthreadcomposition.async-animations" = true;
                  "layers.async-video.enabled" = true;
                  "html5.offmainthread" = true;
                };
              };
            };
          };
          librewolf.enable = true;
          thunderbird = {
            enable = true;
            profiles.default.isDefault = true;
          };
          keepassxc.enable = true;
        };
      }

      (lib.mkIf config.mine.module.home.desktop.comms.enable {
        home.packages = with pkgs; [
          element-desktop
          jami
          signal-desktop-bin
        ];
      })
    ]
  );
}
