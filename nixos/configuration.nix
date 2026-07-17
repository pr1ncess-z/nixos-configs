# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, pkgs, ... }:

{
  # NVIDIA driver, Steam, and other unfree packages required by this config.
  nixpkgs.config.allowUnfree = true;

  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
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
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos-durian"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  hardware = {
    graphics.enable = true;
    nvidia = {
      package = pkgs.nvidia_cachyos;
      open = true;
    };
  };

  # Enable the X11 windowing system.
  services.displayManager.ly.enable = true;
  services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  cachyos.settings = {
    enable = true;
    # All sub-options default to true except GPU-specific ones:
    nvidia.enable = true;        # Uncomment for NVIDIA GPUs
    # amdgpuGcnCompat.enable = true; # Uncomment for older AMD GCN GPUs
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  # NOTE: `wayland.windowManager.hyprland.systemd.enable` is a home-manager option,
  # moved to home.nix (invalid at system scope).
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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
  ];

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
    substituters = [
      "https://cache.nixos.org"           # default NixOS cache
      "https://hyprland.cachix.org"       # Hyprland pre-built binaries
    ];
    trusted-substituters = [              # idk the difference b/w substituters, trusted
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    trusted-users = ["root" "@wheel"];
  };
 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}

