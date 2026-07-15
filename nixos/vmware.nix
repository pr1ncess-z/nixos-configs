{ config, pkgs, ... }:

{
  # ── VMware guest tools ──────────────────────────────────
  virtualisation.vmware.guest.enable = true;

  # ── Use the default kernel (not CachyOS — pointless in a VM) ──
  # Comment out the CachyOS kernel for VM testing:
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;  # skip in VM

  # ── Hyprland needs software rendering in VMware ────────
  # VMware's virtual GPU (SVGA3D) has limited OpenGL support.
  # Hyprland needs these environment variables to work in a VM [1]:
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";      # hardware cursors are broken in VMs [1][2]
    WLR_RENDERER_ALLOW_SOFTWARE = "1";  # allow software rendering fallback [1]
    LIBGL_ALWAYS_SOFTWARE = "1";       # nuclear option: force all software
  };

  # ── VMware virtual GPU needs enough video memory ────────
  # Make sure you allocated 1GB+ in VM Settings → Display
}
