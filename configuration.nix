# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Desktop Environment
  services.desktopManager = {
    plasma6.enable = true;
  };
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clay = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Clay";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal stuff
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nix-search-cli
    openssh
    tree
    # Desktop environment
    kdePackages.kcalc
    kdePackages.kclock
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.sddm-kcm # configuration module for SDDM (which is what...?)
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    # Wayland stuff
    #wl-clipboard # command line copy/paste (? maybe to copy TO terminal?)
    #wayland-utils # no idea
    # Hyprland's default terminal
    kitty # works great
    # Hyprland app launcher
    rofi-wayland # works great
    # Firefox fork
    floorp
    # Novelty terminal commands
    sl
    nyancat
    steam
    home-manager    
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  hardware = {
    # Renamed from opengl.enable
    graphics.enable = true;
    # Most Wayland compositors need this
    nvidia.modesetting.enable = true;
    nvidia.powerManagement.enable = false;
    nvidia.open = false;
    nvidia.nvidiaSettings = true;

  };

  # XDG portal for screen sharing
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Save off the config files for this generation
  system.copySystemConfiguration = true;
  # should copy the configuration.nix to /run/current-system/configuration.nix

  # Configure some packages 
  # PROGRAMS.x requires Home Manager
  #programs.floorp = {
  #  enable = true;
  #};
  #programs.neovim = {
  #  enable = true;
  #  #defaultEditor = true;
  #};
  programs.git = {
    enable = true;
    config = {
      user.name = "Clay Michaels";
      user.email = "clay.michaels@gmail.com";
      user.defaultBranch = "main";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
    };
  };

  # FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
