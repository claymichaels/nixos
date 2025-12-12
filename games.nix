{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # https://wiki.nixos.org/wiki/Minecraft
    prismlauncher # Minecraft
    heroic
  ];

  # https://wiki.nixos.org/wiki/Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # extraCompatPackages = [ proton-ge-bin ]; example
  };

  # https://wiki.nixos.org/wiki/Minecraft_Server
  services.minecraft-server = {
    package = pkgs.papermc;
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = 43000;
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      motd = "Dad's Minecraft Server";
      allow-cheats = false;
    };
  };

  # https://wiki.nixos.org/wiki/Heroic_Games_Launcher
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  # https://journix.dev/posts/gaming-on-nixos/
}
