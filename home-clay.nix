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
    #pkgs.gnomeExtensions.blur-my-shell
    #pkgs.gnomeExtensions.places-status-indicator
    #pkgs.gnomeExtensions.clipboard-indicator
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

  # programs.bash = {
  #		enable = true;
  #    initExtra = ''
  #      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #      then
  #        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #      fi
  #    '';
  #  };
  programs.fish = {
    enable = true;
    functions = {
      # https://alexwlchan.net/2023/fish-venv/
      venv = ''
        function venv --description "Create and activate a new virtual environment"
          echo "Creating virtual environment in "(pwd)"/.venv"
          python3 -m venv .venv --upgrade-deps
          source .venv/bin/activate.fish
          # Append .venv to the Git exclude file, but only if it's not already there.
          if test -e .git
            set line_to_append ".venv"
            set target_file ".git/info/exclude"
            if not grep --quiet --fixed-strings --line-regexp "$line_to_append" "$target_file" 2>/dev/null
              echo "$line_to_append" >> "$target_file"
            end
          end
        end
        function auto_activate_venv --on-variable PWD --description "Auto activate/deactivate virtualenv when I change directories"
          # Get the top-level directory of the current Git repo (if any)
          set REPO_ROOT (git rev-parse --show-toplevel 2>/dev/null)

          # Case #1: cd'd from a Git repo to a non-Git folder
          #
          # There's no virtualenv to activate, and we want to deactivate any
          # virtualenv which is already active.
          if test -z "$REPO_ROOT"; and test -n "$VIRTUAL_ENV"
              deactivate
          end

          # Case #2: cd'd folders within the same Git repo
          #
          # The virtualenv for this Git repo is already activated, so there's
          # nothing more to do.
          if [ "$VIRTUAL_ENV" = "$REPO_ROOT/.venv" ]
              return
          end

          # Case #3: cd'd from a non-Git folder into a Git repo
          #
          # If there's a virtualenv in the root of this repo, we should
          # activate it now.
          if [ -d "$REPO_ROOT/.venv" ]
              source "$REPO_ROOT/.venv/bin/activate.fish" &>/dev/null
          end
        end
      '';
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number relativenumber
      autocmd FileType nix setlocal shiftwidth=2 tabstop=2
      autocmd FileType py setlocal shiftwidth=4 tabstop=4
    '';
    plugins = with pkgs.vimPlugins; [
    ];
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
}
