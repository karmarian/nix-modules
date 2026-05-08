# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mine.module.system.ssh;
in
{
  options.mine.module.system.ssh = {
    enable = lib.mkEnableOption "SSH configuration (client and/or server)";

    client = {
      enable = lib.mkEnableOption "SSH client (ssh, scp, sftp)";
    };

    server = {
      enable = lib.mkEnableOption "SSH server (sshd)";
      ports = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ 22 ];
        description = "Ports on which the SSH server listens.";
      };
      allowUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of usernames allowed to log in via SSH.";
      };
      permitRootLogin = lib.mkOption {
        type = lib.types.enum [
          "yes"
          "without-password"
          "prohibit-password"
          "no"
        ];
        default = "no";
        description = "Whether to permit root login.";
      };
      passwordAuthentication = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to allow password authentication.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # --- SSH CLIENT CONFIGURATION ---
    programs.ssh = lib.mkIf cfg.client.enable {
      # System-wide client defaults (overrides /etc/ssh/ssh_config)
      # These are safe defaults. Your specific 'Host' entries go in ~/.ssh/config
      extraConfig = ''
        # Security: Disable forwarding by default (user can enable per-host)
        ForwardAgent no
        ForwardX11 no
        ForwardX11Trusted no

        # Keep-alive settings
        ServerAliveInterval 60
        ServerAliveCountMax 3

        # Performance
        Compression no

        # Key management
        AddKeysToAgent yes
        HashKnownHosts yes

        # Connection multiplexing (optional, disabled by default for safety)
        ControlMaster no
        ControlPath none
        ControlPersist no
      '';
    };

    # --- SSH SERVER CONFIGURATION ---
    services.openssh = lib.mkIf cfg.server.enable {
      enable = true;

      # Ports
      ports = cfg.server.ports;

      # Security Hardening
      settings = {
        # Authentication
        PasswordAuthentication = cfg.server.passwordAuthentication;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = cfg.server.permitRootLogin;

        # Key-based auth is usually implied if PasswordAuth is false,
        # but we can be explicit if needed.
        PubkeyAuthentication = true;

        # Security: Only allow specific users if list is provided
        AllowUsers = if cfg.server.allowUsers != [ ] then cfg.server.allowUsers else null; # null means "allow all (subject to other constraints)"

        # Security: Disable empty passwords
        PermitEmptyPasswords = false;

        # Security: Limit protocols
        Protocol = 2;

        # Logging
        LogLevel = "INFO";
      };
    };
  };
}
