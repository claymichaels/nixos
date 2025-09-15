# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
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

  # /etc/hosts
  networking.hosts = {
    "192.168.1.235" = ["pi"];
  };

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
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are/13505
  environment.gnome.excludePackages = with pkgs; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    #eog         # image viewer
    epiphany    # web browser
    #gedit       # text editor
    #simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    #evince      # document viewer
    #file-roller # archive manager
    #geary       # email client
    seahorse    # password manager
    gnome-clocks
    gnome-calendar
    gnome-characters
    gnome-contacts
    gnome-font-viewer
    gnome-maps
    gnome-weather
    gnome-terminal
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clay = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Clay";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
  home-manager.users.clay = ./home-clay.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal stuff
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #neovim
    nix-search-cli
    tree
    openssh
    wget
    kitty # works great
    # Hyprland app launcher
    #rofi-wayland # works great
    # Work
    slack
    zoom
    libreoffice
    sqlitebrowser
    # Firefox fork
    floorp
    vlc
    prismlauncher
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

  # XDG portal for screen sharing # From hyprland configs. May not be necessary.
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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

  programs.steam = {
    enable = true;
    # extraCompatPackages = [ proton-ge-bin ]; example
  };
}
