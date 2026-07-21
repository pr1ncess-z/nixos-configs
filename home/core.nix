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
    zsh = {
      enable = true;
    };
    vim = {
      enable = true;
    };
    neovim = {
      enable = true;
    };
    alacritty = {
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
      enable = true;
      enableSessionWide = true; # Injects the necessary environment variables
      settings = {
        full = true;
        fps_limit = [ 60 120 144 ];
        hud_compact = true;
        cpu_temp = true;
        gpu_temp = true;
      };
    };
  };

  services = {
    hyprpaper = {
      enable = true;
    };
    hypridle = {
      enable = true;
    };
    hyprpolkitagent = {
      enable = true;
    };
    cliphist = {
      enable = true;
      clipboardPackage = pkgs.wl-clipboard;
    };
  };
}

