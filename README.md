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

error: file 'plasma-manager/modules' was not found in the Nix search path (add it using $NIX_PATH or -I)
Solution:

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



