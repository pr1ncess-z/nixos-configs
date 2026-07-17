{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  home.username = "will";
  home.homeDirectory = "/home/will";
}
