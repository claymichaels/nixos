{ config, pkgs, ... }:
{
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
    #gnome-camera or camera - neither work
    gnome-connections
    gnome-clocks
    gnome-calendar
    gnome-characters
    gnome-contacts
    gnome-font-viewer
    gnome-maps
    gnome-weather
    gnome-terminal
  ];
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    #gnomeExtensions.blur-my-shell
    #gnomeExtensions.just-perfection
    #gnomeExtensions.arc-menu
  ];
}
