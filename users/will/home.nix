{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  # home.file.".vim/colors/badwolf.vim".source = ./config/vim/colors/badwolf.vim;
  # home.file.".vimrc".source = ./config/vim/vimrc;
  # home.file.".config/hypr/hyprland.lua".source = ../../hosts/durian/config/hypr/hyprland.lua;

  home.packages = with pkgs; [
    vimPlugins.vim-pathogen
  ];

  home.username = "will";
  home.homeDirectory = "/home/will";

  programs.git = {
    enable = true;
    userName = "Will Zhou";
    userEmail = "smithy@pr1ncess.net";
  };
}
