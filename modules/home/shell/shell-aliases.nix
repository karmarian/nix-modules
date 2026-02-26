# SPDX-FileCopyrightText: 2024 karmar <karmar@posteo.de>
# SPDX-License-Identifier: CC-BY-SA-4.0

{
  ll = "ls -ls";
  dir = "ls -ba";
  ss = "ps -aux";
  dot = "ls .[a-zA-Z0-9_]*";
  c = "clear";
  m = "more";
  j = "jobs";

  karmar-repl = "nix repl --file '<nixpkgs>'";
  karmar-git-checkfolders = ''
    find . -name ".git" -type d | while read gitdir; do 
      repodir=$(dirname "$gitdir")
      echo "Check folder: $repodir"
      ( cd "$repodir" && git fetch --all && git log --branches --not --remotes && git stash list )
    done
  '';
  karmar-gitannex-sync = ''
    for dir in */; do
      if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
        echo "Sync folder: $dir";
        ( cd "$dir" && git annex add . && git add . && git annex sync --content );
      fi;
    done
  '';
}
