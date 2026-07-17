{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v4;

  # ── sched-ext BPF scheduler ──
  services.scx.enable = true;
  services.scx.scheduler = "scx_bpfland";

  # ── Gaming-specific kernel params (not in cachyos-settings) ──
  boot.kernelParams = [
    "nowatchdog"
    "nvidia_drm.modeset=1"
    "tsc=reliable" 
    "clocksource=tsc"
    "intel_pstate=active"
    "preempt=full"
    "pcie_aspm=performance"
    "transparent_hugepage=madvise"
    "splash"
    "rw"
  ];
 
  # ── Game-specific sysctl (Star Citizen / Cyberpunk) ──
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # ── Gaming packages ──
  hardware.graphics.enable32Bit = true;
  programs.steam.enable = true;

  # ── CachyOS system tuning (replaces manual sysctls, governor, etc.) ──
  # Enabled in configuration.nix: cachyos.settings.enable = true;
}
