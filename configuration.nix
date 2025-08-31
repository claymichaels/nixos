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

  networking.hostName = "nixos"; # Define your hostname.
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
    # Hyprland "taskbar"
    waybar
    # notifications
    mako
    # Required for mako
    libnotify
    # Wallpaper daemon
    swww
    # Hyprland's default terminal
    kitty
    # Hyprland app launcher
    rofi-wayland
    # Firefox fork
    floorp
    # Network Manager applet (for the bar, I think?)
    networkmanagerapplet
    # window arrangement helper
    nwg-displays
    # Novelty terminal commands
    sl
    nyancat
    # Steam
    steam
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


  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true; # causes error "no longer needed"
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Prevents cursor from going invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Tell Electron apps to use Wayland (like Discord)
    NIXOS_OZONE_WL = "1";
  };

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

  # Trying to get it to actually start!
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  # Try to start with NumLock - breaks login?
  #services.xserver.displayManager.setupCommands = ''
  #  ${pkgs.numlockx}/bin/numlockx on
  #'';

  # Save off the config files for this generation
  environment.etc."current/nix".source=/etc/nixos/configuration.nix;
  environment.etc."current/hyp".source=/home/clay/.config/hypr/hyprland.conf;

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
}
