let
  # External let binding to fetch nix-flatpak without
  # causing infinite recursion.
  pkgs = import <nixpkgs> {};
  nix-flatpak = pkgs.fetchFromGitHub {
    owner = "gmodena";
    repo = "nix-flatpak";
    rev = "v0.6.0";
    hash = "sha256-iAVVHi7X3kWORftY+LVbRiStRnQEob2TULWyjMS6dWg=";
  };
  # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      "${nix-flatpak}/modules/nixos.nix"
    ];
    services.flatpak = {
      enable = true;
      packages = ["org.vinegarhq.Sober"];
      uninstallUnmanaged = true;
      # overrides = {
      # "org.vinegarhq.Sober".Context = {
      # "Permissions" = {
      # "devices" = "input";
      # };
      # };
      # };
    };
  }
