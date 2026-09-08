{ pkgs, ...}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Enable XDG Desktop Portals for Hyprland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-generic
    ];
    config.common.default = "*";
  };

  services = {
    displayManager.ly.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      wl-clipboard
      wlsunset
      kitty # required for default Hyprland config

      
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.oxygen-icons
      kdePackages.kde-gtk-config
      kdePackages.qt6gtk2
      kdePackages.filelight
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.kdegraphics-thumbnailers # For image thumbnails
      kdePackages.qtwayland                # Wayland support for Qt apps
      kdePackages.kcalc # Calculator
      kdePackages.kcharselect # Character map
      kdePackages.kclock # Clock app
      kdePackages.kcolorchooser # Color picker
      kdePackages.kolourpaint # Simple paint program
      kdePackages.ksystemlog # System log viewer
      # kdePackages.sddm-kcm # SDDM configuration module
      kdiff3 # File/directory comparison tool
      # libsForQt5.qtstyleplugin-kvantum     # Optional: For styling Qt apps
      # qt6Packages.qtstyleplugin-kvantum
      # kdePackages.qtstyleplugin-kvantum
     ];
  };
}
