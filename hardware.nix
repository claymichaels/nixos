# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
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
    # Printer on RPi CUPS was stuck on "No suitable destination host found by cups-browsed"
    #   Stopped cups-browsed , deleted printer in local CUPS, added printer in local CUPS, restarted cups-browsed
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
}
