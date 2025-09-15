{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "clay";
  home.homeDirectory = "/home/clay";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    #(pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/clay/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.rofi = {
    enable = true;
    theme = "/nix/store/4p8f4jz6a4qv7c4gmlm367vyfjvhnplk-rofi-1.7.9+wayland1/share/rofi/themes/solarized.rasi";
  };

  # Make a .Desktop file for Sqlitebrowser
  xdg.desktopEntries.sqlitebrowser = {
    name = "Sqlite Browser";
    exec = "${pkgs.sqlitebrowser}/bin/sqlitebrowser";
  };
  # Register SQLitebrowser as the default app for .sqlite3
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/vnd.sqlite3" = "sqlitebrowser.desktop";
    };
  };
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number relativenumber
    '';
  };

  # monitor setup for Gnome
  home.file.".config/monitors.xml".text = ''
  <monitors version="2">
  <configuration>
    <layoutmode>physical</layoutmode>
    <logicalmonitor>
      <x>1920</x>
      <y>0</y>
      <scale>1</scale>
      <monitor>
        <monitorspec>
          <connector>HDMI-2</connector>
          <vendor>ACR</vendor>
          <product>Acer S232HL</product>
          <serial>LQY080094201</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60.000</rate>
        </mode>
      </monitor>
    </logicalmonitor>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <scale>1</scale>
      <monitor>
        <monitorspec>
          <connector>HDMI-1</connector>
          <vendor>ACR</vendor>
          <product>Acer S232HL</product>
          <serial>LQY080094201</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60.000</rate>
        </mode>
      </monitor>
    </logicalmonitor>
    <logicalmonitor>
      <x>0</x>
      <y>1080</y>
      <scale>1</scale>
      <primary>yes</primary>
      <monitor>
        <monitorspec>
          <connector>DP-1</connector>
          <vendor>DEL</vendor>
          <product>DELL U3818DW</product>
          <serial>97F8P0AT0OZL</serial>
        </monitorspec>
        <mode>
          <width>3840</width>
          <height>1600</height>
          <rate>59.994</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  </configuration>
  '';
}
