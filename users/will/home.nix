{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  home.file.".vim/colors/badwolf.vim".source = ./config/vim/colors/badwolf.vim;
  home.file.".vimrc".source = ./config/vim/vimrc;

  home.packages = with pkgs; [
    vimPlugins.vim-pathogen
  ];

  home.username = "will";
  home.homeDirectory = "/home/will";
}
