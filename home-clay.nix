{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./monitors.nix
    ./browsers.nix
  ];

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
    #pkgs.zoxide
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
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza -lh --git";
      lh = "eza -lha --git";
      vim = "hx";
    };
    plugins = [
      # Need to figure out plugins. Can Fisher be installed on Nixos?
      # https://github.com/kidonng/nix.fish
      # https://github.com/kbryy/ls-after-cd.fish
    ];
    functions = {
      # https://alexwlchan.net/2023/fish-venv/
      cd = {
        description = "PWD and LS after a CD";
        body = "z $argv && pwd && eza";
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "adwaita_dark";
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
      {
        name = "python";
        auto-format = true;
      }
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };

  programs.zoxide = {
    # CD replacement
    enable = true;
    enableFishIntegration = true;
    options = [
    ];
  };

  programs.eza = {
    # LS replacement
    enable = true;
    enableFishIntegration = true;
    git = true;
    # theme = https://github.com/eza-community/eza#custom-themes
    icons = "never";
  };
}
