{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default
      # inputs.ssbm-nix.nixosModule
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
  networking.firewall = {
    enable = true;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose";
  };

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


  # 3. Optional: Enable the GameCube controller adapter overclock kernel module
  # ssbm.cache.enable = true;
  # ssbm.gcc.oc-kmod.enable = true; 
  programs.vim = {
    enable = true;
    defaultEditor = true;  
  };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  # programs.appimage.package = pkgs.appimage-run.override 
  #   {
  #     extraPkgs = pkgs: 
  #     [
  #       pkgs.icu
  #       pkgs.libxcrypt-legacy
  #       pkgs.python312
  #       pkgs.python312Packages.torch
  #     ]; 
  #   };

  programs.nix-ld.enable = true;
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
  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors = {
  #     hyprland = {
  #       prettyName = "hyprland";
  #       comment = "hyprland on UWSM";
  #       binPath = "/run/current-system/sw/bin/Hyprland";
  #     };
  #     mango = {
  #       prettyName = "mango";
  #       comment = "mango on UWSM";
  #       binPath = "/run/current-system/sw/bin/mango";
  #     };
  #   };
  # };
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
  services.resolved.enable = true;
  services.tailscale = {
    enable = true;
    authKeyFile = "/var/lib/tailscale-key";
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];

  # 3. Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    kitty # required for default Hyprland config
    ripgrep
    alacritty
    bat
    steam-run
    xdg-user-dirs
    wlsunset
    gh
    discord
    cifs-utils
    nix-alien
    altus
    bun
    nodejs
    pi-coding-agent
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdePackages.dolphin
    kdePackages.okular
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

    FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
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
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [ "will" ];
      MaxAuthTries = 9;
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
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", TAG+="uaccess" 
  '';

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
  ];
  fonts.enableDefaultPackages = true;
  
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    subpixel.rgba = "rgb";
    subpixel.lcdfilter = "default";
    cache32Bit = true;
    useEmbeddedBitmaps = true;
    hinting = {
      enable = true;
      style = "slight";
      autohint = true;
    };
    defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      monospace = [ "FiraCode Nerd Font" "Noto Sans Mono" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir>/home/will/local/share/fonts</dir>
      <match target="pattern">
        <test name="family">
          <string>system-ui</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>sans-serif</string>
        </edit>
      </match>
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

