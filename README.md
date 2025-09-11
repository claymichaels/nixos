# NIXOS notes

sudo nixos-rebuild switch   # builds a generation and switches to it.

sudo nixos-rebuild test     # Builds a generation but doesn't add it to the boot menu, to make sure there's no errors. Useful for intermediate changes.

sudo nix-env --list-generations --profile /nix/var/nix/profiles/system # Lists system packages

sudo nix-env --delete-generations <gen number>  # Deletes a generation

sudo nixos-rebuild switch --profile-name "foo"  # I think I can use profiles like GIT branches to switch DEs?

nix-search "foo"    # Search available packages

nix-shell -p foo    # start a temporary shell with the package Foo. Useful for using one-off utilities

# Using Python

## Temporary installs for running a script

nix-shell -p python313

nix-shell -p virtualenv

virtualenv venv

pip install foo

python bar.py

## Permanent install

Haven't tried yet.

# in configuration.nix

environment.etc."current/nix".source=/etc/nixos/configuration.nix;  # Copies the config file into /etc so I can check which file created this generation

**Don't do that with Flakes! Flakes causes it to be more picky, and mentioning the actual filesystem seems to be a no-no.**

QuadRadical in the Matrix chat sugggests using inputs.self instead. Will play.

# Kitty Terminal commands

CTRL+SHIFT+C    Copy

SHIFT+INSERT    Paste

# Home Manager

home.packages=[pkgs.whatever]

Requires the "pkgs."

If a Nix "module" exists for a package, you can do a top level programs.blah = {}

Jasi on NIXOS Matrix suggests reading https://nix.dev/tutorials/module-system/a-basic-module/ to learn about multiple DEs.


# Errors seen

*When running nixos-rebuilld*

error: file 'plasma-manager/modules' was not found in the Nix search path (add it using $NIX_PATH or -I)
Solution:

*When running nixos-rebuilld*

*Error:* Failed to start Home Manager environment for clay.

*Link:*https://discourse.nixos.org/t/failed-to-start-home-manager-environment-for-user/50254

*Solution:* Home-Manager doesn't want to overwrite a file

journalctl -xe --unit home-manager-clay # To find out which file is already present

Sep 10 17:18:25 nixos-pc hm-activate-clay[184905]: Starting Home Manager activation
Sep 10 17:18:25 nixos-pc hm-activate-clay[184905]: Activating checkFilesChanged
Sep 10 17:18:25 nixos-pc hm-activate-clay[184905]: Activating checkLinkTargets
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]: Existing file '/home/clay/.config/rofi/config.rasi' is in the way of '/nix/store/385364a05la57cx2pi7j5bjmhwh972s4-home-manager-files/.config/rofi/config.rasi'
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]: Please do one of the following:
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]: - Move or remove the above files and try again.
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]: - In standalone mode, use 'home-manager switch -b backup' to back up
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]:   files automatically.
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]: - When used as a NixOS or nix-darwin module, set
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]:     'home-manager.backupFileExtension'
Sep 10 17:18:25 nixos-pc hm-activate-clay[184949]:   to, for example, 'backup' and rebuild.

In this case, I moved the ~/.config/rofi/config.rasi to config.rasi.backup, and it was replaced with a symlink to the home-manager store folder.

When I added a new MIME type inorder to set a default application, (sqlitebrowser), it came up for /home/clay/.config/mimeapps.list.

# Default apps

After adding the pkgs.sqlitebrowser to home-manager, KDE didn't recognize it as the default app. 

https://wiki.nixos.org/wiki/Default_applications


# Git

Because I'm learning as I go.

## New repo

1. Create the repository on Github

2. mkdir for the local repo

3. git init # Starts git tracking in the folder

4. git remote add origin <url copied from github>


## Commiting changes

1. git status  # see current branch and files with changes

2. git add <filename> # add the (changed or new) file to the commit

3. git commit -m "<commit message>" # Add the message about what you did

4. git push origin <branch (default "main")> # Sends it up to github

## Branches

1. git branch # Lists existing branches

2. git branch <branch name> @ Makes a new branch

3. git checkout # Switch to another branch

4. git push origin <branch name> # Upload the changes



