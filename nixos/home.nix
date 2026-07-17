{ config, pkgs, inputs, ... }:

{
  home.username = "will";
  home.homeDirectory = "/home/will";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    tree
    wget
    grim
    slurp
  ];

  programs = {
    zsh = {
      enable = true;
    };
    vim = {
      enable = true;
    };
    neovim = {
      enable = true;
    };
    kitty = { # needed for default hyprland config
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

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.enable = false;
  # hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

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

