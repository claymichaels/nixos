{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./gnome.nix
    ./hardware.nix
    ./games.nix
    ./flatpak.nix
    <home-manager/nixos>
    # "${nix-flatpak}/modules/nixos.nix"
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clay = {
    #shell = "bash";
    isNormalUser = true;
    description = "Clay";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # packages = with pkgs; [];
  };
  home-manager.users.clay = ./home-clay.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal stuff
    nix-search-cli
    tree
    openssh
    wget
    procps
    slack
    zoom-us
    libreoffice
    sqlitebrowser
    firefox
    vlc
    #prismlauncher # Minecraft
    dconf2nix # Helps turn Gnome settings into Nix HM
    vivaldi
    python313
    python313Packages.python-lsp-server
    python313Packages.jedi-language-server
    python313Packages.ruff
    python313Packages.virtualenv
    #devenv
    trashy # trash cli to replace RM
    yt-dlp # Youtube downloader
    discord
    fd # Find
    lazygit # Awesome git CLI
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

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
      cls = "clear";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5" # NO IDEA what is using this. Heroic or flatpack? Last things I added.
    # Required becase SOMETHING is using this version, and it breaks nixos-rebuild
  ];
}
