{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default
      inputs.nixvim.nixosModules.nixvim
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
  boot.supportedFilesystems = [ "nfs" ];

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

  services.power-profiles-daemon.enable = false;
  powerManagement.cpuFreqGovernor = "performance";
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

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
	General = {
	  # Shows battery charge of connected devices on supported
	  # Bluetooth adapters. Defaults to 'false'.
	  Experimental = true;
	  # When enabled other devices can connect faster to us, however
	  # the tradeoff is increased power consumption. Defaults to
	  # 'false'.
	  FastConnectable = true;
	};
	Policy = {
	  # Enable all controllers when they are found. This includes
	  # adapters present on start as well as adapters that are plugged
	  # in later on. Defaults to 'true'.
	  AutoEnable = true;
	};
      };
    };

  };

  cachyos.settings = {
    enable = true;
    nvidia.enable = true;
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/85977e05-842d-4be8-90ae-3280be6b242d";
    fsType = "ext4";
    options = [ "rw" "suid" "dev" "exec" "auto" "nouser" "async" ];
  };
  fileSystems."/mnt/vault" = {
    device = "192.168.50.249:/Vault";
    fsType = "nfs4";
    options = [ "x-systemd.automount" "noauto" ];
  };


  # 3. Optional: Enable the GameCube controller adapter overclock kernel module
  # ssbm.cache.enable = true;
  # ssbm.gcc.oc-kmod.enable = true; 
  programs.vim = {
    enable = true;
  };
  programs.labwc = {
    enable = true;
  };
  # programs.wayfire = {
  #   enable = true;
  #   plugins = with pkgs.wayfirePlugins; [
  #     wcm
  #   ];
  # };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.thunderbird.enable = true;

  programs.nix-ld.enable = true;
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };
  # programs.waybar.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    histSize = 1000000;
    syntaxHighlighting.enable = true;
  };
  programs.git = {
    enable = true;
  };
  # programs.nixvim = {
  #   enable = true;

  #   colorschemes.gruvbox.enable = true;
  #   plugins.lualine.enable = true;
  #   plugins.lspconfig.enable = true;
  #   plugins.treesitter.enable = true;
  # };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
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
  programs.dconf.enable = true;

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
  services = {
    # desktopManager.plasma6.enable = true;
    displayManager.ly.enable = true;
    displayManager.sessionPackages = [ 
      pkgs.labwc 
      # pkgs.wayfire
    ];
    # displayManager.sddm.enable = true;
    # displayManager.sddm.wayland.enable = true;
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

    
    grim slurp hyprpicker wl-clipboard tesseract imagemagick zbar curl
    translate-shell wl-screenrec ffmpeg gifski jq
    python3 python314Packages.pygobject3 xdg-desktop-portal
    flameshot
    luaPackages.tree-sitter-cli
    ddcutil
    labwc-tweaks
    labwc-menu-generator
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
    helix
    pi-coding-agent
    wezterm
    ungoogled-chromium
    onlyoffice-desktopeditors
    nixd
    lua-language-server
    kdePackages.breeze-icons
    kdePackages.oxygen-icons
    kdePackages.dolphin
    kdePackages.okular
    kdePackages.kdegraphics-thumbnailers # For image thumbnails
    kdePackages.qtwayland                # Wayland support for Qt apps
    # kdePackages.kcalc # Calculator
    # kdePackages.kcharselect # Character map
    # kdePackages.kclock # Clock app
    # kdePackages.kcolorchooser # Color picker
    # kdePackages.kolourpaint # Simple paint program
    # kdePackages.ksystemlog # System log viewer
    # kdePackages.sddm-kcm # SDDM configuration module
    # kdiff3 # File/directory comparison tool
    libsForQt5.qtstyleplugin-kvantum     # Optional: For styling Qt apps
    # qt6Packages.qtstyleplugin-kvantum
    # kdePackages.qtstyleplugin-kvantum
    
    hardinfo2
    wl-clipboard
    wayland-utils
    vlc
  ];

  # environment.plasma6.excludePackages = with pkgs; [
  #   kdePackages.elisa # Music player
  #   kdePackages.kdepim-runtime # Akonadi agents
  #   kdePackages.kmahjongg
  #   kdePackages.kmines
  #   kdePackages.konversation # IRC client
  #   kdePackages.kpat # Solitaire
  #   kdePackages.ksudoku
  #   kdePackages.ktorrent
  # ];
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.sessionVariables = {
    # Tell Qt apps to use Wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    
    # Ensure Dolphin can find system icons
    XDG_DATA_DIRS = [ "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" ];

    FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
  };

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

