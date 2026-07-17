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
    };
  };
}

