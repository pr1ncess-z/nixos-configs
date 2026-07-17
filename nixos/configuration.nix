{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
      efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
      };
      grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;  # detects Windows
      };
  };

  networking.hostName = "nixos-durian";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "America/New_York";

  hardware = {
    graphics.enable = true;
    nvidia = {
      package = pkgs.nvidia_cachyos;
      open = true;
    };
  };

  # Don't forget to set a password with ‘passwd’.
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  cachyos.settings = {
    enable = true;
    nvidia.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "hyprland";
        comment = "hyprland on UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
      mango = {
        prettyName = "mango";
        comment = "mango on UWSM";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };
  };
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    kitty # required for default Hyprland config
  ];

  services.displayManager.ly.enable = true;
  services.xserver = {
      videoDrivers = [ "nvidia" ];
  };
  services.openssh.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
    nerd-fonts.geist-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    ucs-fonts
    open-fonts
    font-adobe-100dpi
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [  # idk the difference b/w substituters and trusted so enabling both
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    trusted-users = ["root" "@wheel"];
  };

  system.stateVersion = "26.05";
}

