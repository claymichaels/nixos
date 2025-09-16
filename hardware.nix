# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  hardware = {
    # Renamed from opengl.enable
    graphics.enable = true;
    # Most Wayland compositors need this
    nvidia.modesetting.enable = true;
    nvidia.powerManagement.enable = false;
    nvidia.open = false;
    nvidia.nvidiaSettings = true;

  };

  # Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
}
