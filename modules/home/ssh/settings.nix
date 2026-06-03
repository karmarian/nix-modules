# SPDX-FileCopyrightText: 2025 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  "*" = {
    forwardAgent = false;
    addKeysToAgent = "yes";
    compression = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    controlMaster = "no";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
  };

  # "vm" = {
  #   HostName = "vm";
  #   User = "me";
  #   IdentityFile = "/home/me/.ssh/id_ed25519_vm";
  # };
}
