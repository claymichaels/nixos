{
  config,
  pkgs,
  ...
}: {
  # Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are/13505
  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    cheese # photo booth
    #eog         # image viewer
    epiphany # web browser
    #gedit       # text editor
    #simple-scan # document scanner
    totem # video player
    yelp # help viewer
    #evince      # document viewer
    #file-roller # archive manager
    geary # email client
    seahorse # password manager
    # gnome-camera # or camera - neither work
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
    gnomeExtensions.places-status-indicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.extension-list
    gnomeExtensions.tiling-assistant
    gnomeExtensions.random-wallpaper
    gnomeExtensions.task-widget
  ];
  home-manager.users.clay = {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      settings."org/gnome/desktop/peripherals/mouse".speed = "1.0";
      settings."org/gnome/shell" = {
        disable-extension-version-validation = true;
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "vivaldi-stable.desktop"
          "slack.desktop"
          "com.belmoussaoui.Authenticator.desktop"
          "org.gnome.Console.desktop"
        ];
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          "places-menu@gnome-shell-extensions.gcampax.github.com"
          "clipboard-indicator@tudmotu.com"
          "extension-list@tu.berry"
          "tiling-assistant@leleat-on-github"
          "randomwallpaper@iflow.space"
          "task-widget@juozasmiskinis.gitlab.io"
        ];
      };
      settings."org/gnome/shell/extensions/extension-list" = {
        extension-appid = "org.gnome.Extensions.desktop";
        filter-button = false;
        remove-button = false;
        homepage-button = false;
        ignore-button = false;
      };
      settings."org/gnome/shell/extensions/tiling-assistant" = {
        window-gap = 20;
        single-screen-gap = 14;
        maximize-with-gaps = true;
      };
      settings."org/gnome/shell/extensions/space-iflow-randomwallpaper" = {
        fetch-on-startup = true;
        history-length = 5;
        hide-panel-icon = true;
      };
      settings."org/gnome/shell/extensions/task-widget" = {
        merge-task-lists = true;
        hide-empty-completed-task-lists = true;
        disabled-task-lists = ["system-task-list"];
      };
      settings."org/gnome/desktop/wm/keybindings" = {
        move-to-monitor-up = ["<Shift><Super>KP_Up"];
        move-to-monitor-down = ["<Shift><Super>KP_Down"];
        move-to-monitor-left = ["<Shift><Super>KP_Left"];
        move-to-monitor-right = ["<Shift><Super>KP_Right"];
      };
      settings."org/gnome/console" = {
        shell = ["FISH"];
      };
      settings."org/gnome/nautilus/preferences" = {
        click-policy = "single";
      };
    }; # dconf
  }; # home-manager.users.clay
}
