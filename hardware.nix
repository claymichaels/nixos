# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    # From https://search.nixos.org/options?channel=26.05&query=graphics.enable&type=options#show=option%253Ahardware.graphics.enable
    # This option should be enabled by default by the corresponding modules, so you do not usually have to set it yourself.
    # Whether to enable hardware accelerated graphics drivers
    # graphics.enable = true;

    # From https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/nvidia/pascal/default.nix
    nvidia.open = false;
    nvidia.package = lib.mkDefault config.boot.kernelPackages.legacy_580;

    # Whether to enable nvidia-settings, NVIDIA’s GUI configuration tool. I have this enabled but it doesn't seem to do anything.
    # nvidia.nvidiaSettings = true;

    # https://wiki.nixos.org/wiki/NVIDIA
    # Wayland requires kernel mode setting (KMS) to be enabled (Highly Recommended)
    nvidia.modesetting.enable = true;
    # Graphical corruption and system crashes on suspend/resume
    # powerManagement.enable = true can sometimes fix this, but is itself unstable and is known to cause suspend issues
    nvidia.powerManagement.enable = true; # Recommended by a Lemming
  };

  # From https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/nvidia/default.nix
  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

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
