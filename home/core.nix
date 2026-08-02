{ pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    tree
    wget
    grim
    slurp
    cups-pdf-to-pdf
  ];

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
    };
    fuzzel = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
    hyprlock = {
      enable = true;
    };
    firefox = {
      enable = true;
    };
    mangohud = {
      enable = false;
      enableSessionWide = false; # Injects the necessary environment variables
      settings = {
        full = false;
        fps_limit = [ 144 ];
        hud_compact = true;
        cpu_temp = false;
        gpu_temp = false;
      };
    };
  };

  services = {
    hyprpaper = {
      enable = true;
    };
    # hypridle = {
    #   enable = true;
    # };
    hyprpolkitagent = {
      enable = true;
    };
  };
}

