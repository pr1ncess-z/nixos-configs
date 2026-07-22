{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default
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
  networking.firewall.checkReversePath = "loose";

  time.timeZone = "America/New_York";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }]; 
  zramSwap.enable = true;

  hardware = {
    graphics.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      prime = {
        sync.enable = true;
        
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };

    bluetooth.enable = true;
  };

  cachyos.settings = {
    enable = true;
    nvidia.enable = true;
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/85977e05-842d-4be8-90ae-3280be6b242d";
    fsType = "ext4";
    options = [ "rw" "suid" "dev" "exec" "auto" "nouser" "async" ] ;
  };


  programs.vim = {
    enable = true;
    defaultEditor = true;  
  };
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    histSize = 1000000;
    syntaxHighlighting.enable = true;
  };
  programs.git = {
    enable = true;
  };
  programs.neovim = {
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
  programs.steam.enable = true;
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
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland 
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = "*";
  };
  
  # Ensure system d-bus and XDG features integrate correctly
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.tailscale = {
    enable = true;
  };
  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [
    kitty # required for default Hyprland config
    alacritty
    bat
    xdg-user-dirs
    wlsunset
    gh
    discord
    tailscale-systray
    cifs-utils
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdePackages.dolphin
    kdePackages.kdegraphics-thumbnailers # For image thumbnails
    kdePackages.qtwayland                # Wayland support for Qt apps
    libsForQt5.qtstyleplugin-kvantum     # Optional: For styling Qt apps
  ];
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

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
  services.openssh = {
    enable = true;  
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "will" ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    liberation_ttf
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
  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    cache32Bit = true;
    defaultFonts = {
      sansSerif = [ "Liberation Sans" "Noto Sans" "Noto Sans CJK KR" ];
      serif = [ "Liberation Serif" "Noto Serif" ];
      monospace = [ "FiraCode Nerd Font" "Noto Sans Mono" ];
    };
  };
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>Segoe UI</family>
        <prefer>
          <family>Liberation Sans</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>system-ui</family>
        <prefer>
          <family>Liberation Sans</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>-apple-system</family>
        <prefer>
          <family>Liberation Sans</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>BlinkMacSystemFont</family>
        <prefer>
          <family>Liberation Sans</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

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

