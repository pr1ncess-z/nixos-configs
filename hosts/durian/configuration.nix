{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
      systemd-boot.enable = false;
      efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
      };
      grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          # useOSProber = true;  # detects Windows but slow on every rebuild
          extraEntries = ''
            menuentry "Windows" {
              insmod part_gpt
              insmod fat
              insmod search_fs_uuid
              insmod chain
              search --fs-uuid --set=root A8BB-7831
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
      };
  };

  networking.hostName = "nixos-durian";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "America/New_York";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }]; 
  zramSwap.enable = true;

  hardware = {
    graphics.enable = true;
    nvidia = {
      package = pkgs.nvidia_cachyos;
      open = true;
    };
  };

  cachyos.settings = {
    enable = true;
    nvidia.enable = true;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;  
  };
  programs.git = {
    enable = true;
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
  programs.thunar = {
    enable = true;
  };
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  xdg.menus.enable = true;
  # Enable XDG Desktop Portals for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };
  
  # Ensure system d-bus and XDG features integrate correctly
  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    kitty # required for default Hyprland config
    bat
    kdePackages.dolphin
    kdePackages.kdegraphics-thumbnailers # For image thumbnails
    kdePackages.qtwayland                # Wayland support for Qt apps
    libsForQt5.qtstyleplugin-kvantum     # Optional: For styling Qt apps
  ];

  environment.sessionVariables = {
    # Tell Qt apps to use Wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    
    # Ensure Dolphin can find system icons
    XDG_DATA_DIRS = [ "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" ];
  };

  services.displayManager.ly.enable = true;
  services.xserver = {
      videoDrivers = [ 
        "modesetting"
        "nvidia" 
      ];
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

