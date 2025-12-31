# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
in
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
      <home-manager/nixos>
      "${nix-flatpak}/modules/nixos.nix"
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
      packages = with pkgs; [];
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
      dconf2nix
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
    ];

    # fetchFromGitHub {
    #   owner = "gmodena";
    #   repo = "nix-flatpak";
    #   rev = "v0.6.0";
    #   hash = "sha256-iAVVHi7X3kWORftY+LVbRiStRnQEob2TULWyjMS6dWg=";
    # };
    # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

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

    # XDG portal for screen sharing # From hyprland configs. May not be necessary.
    #xdg.portal.enable = true;
    #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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

    services.flatpak = {
      enable = true;
      packages = ["org.vinegarhq.sober"];
    };
    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  }
