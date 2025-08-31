# nixos

Notes:

sudo nixos-rebuild switch   # builds a generation and switches to it.
sudo nixos-rebuild test     # Builds a generation but doesn't add it to the boot menu, to make sure there's no errors. Useful for intermediate changes.
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system # Lists system packages (configuration.nix?)
sudo nix-env --delete-generations <gen number>  # Deletes a generation
sudo nixos-rebuild switch --profile-name "foo"  # I think I can use this to switch DEs?
nix-search "foo"    # Search available packages
nix-shell -p foo    # start a temporary shell with the package Foo. Useful for using one-off utilities

# in configuration.nix
environment.etc."current/nix".source=/etc/nixos/configuration.nix;  # Copies the config file into /etc so I can check which file created this generation


## Kitty
CTRL+SHIFT+C    Copy
SHIFT+INSERT    Paste

Jasi on NIXOS Matrix suggests reading https://nix.dev/tutorials/module-system/a-basic-module/ to learn about multiple DEs.
