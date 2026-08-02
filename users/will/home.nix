{pkgs, inputs, lib, ...}: {
  imports = [
    ../../home/core.nix
    # inputs.ssbm-nix.homeManagerModule
  ];

  # home.file.".vim/colors/badwolf.vim".source = ./config/vim/colors/badwolf.vim;
  # home.file.".vimrc".source = ./config/vim/vimrc;
  # home.file.".config/hypr/hyprland.lua".source = ../../hosts/durian/config/hypr/hyprland.lua;

  # home.packages = with pkgs; [
  #   vimPlugins.vim-pathogen
  # ];

  home.username = "will";
  home.homeDirectory = "/home/will";

  programs.git = {
    enable = true;
    settings = {
       user.name = "Will Zhou";
       user.email = "smithy@pr1ncess.net";
    };
  };

  programs.gh = {
    enable = true;
    extensions = [
      pkgs.gh-dash
      pkgs.gh-eco
    ];
    
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };

    gitCredentialHelper.enable = true;
  };

  # ssbm.slippi-launcher = {
  #   enable = true;
  #   isoPath = "/home/will/Games/SSBM.iso"; # Replace with your actual path
  # }; 
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      telescope-nvim
      lualine-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
    ];
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./config/nvim/init.lua}
      EOF
    '';
  };

  programs.zsh = {
    enable= true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";

    initContent = ''
      zmodload zsh/datetime

      bindkey "\e[1;3D" backward-word
      bindkey "\e[1;3C" forward-word
      
      function chpwd() {
        emulate -L zsh
        ls -a
      }

      git_prompt() {
        git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    
        local branch staged unstaged untracked out
    
        branch=$(git branch --show-current 2>/dev/null)
    
        staged=$(git diff --cached --name-only 2>/dev/null | wc -l)
        unstaged=$(git diff --name-only 2>/dev/null | wc -l)
        untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
    
        out="%F{214}[$branch"
    
        (( staged )) && out+=" %F{108}+$staged%f"
        (( unstaged )) && out+=" %F{167}-$unstaged%f"
        (( untracked )) && out+=" %F{208}?$untracked%f"
    
        out+="]"
    
        printf "%s" "$out"
      }
    
      RPROMPT="%T"

      setopt prompt_subst
    
      PROMPT='%F{108}%n%f:%F{214}%~ %f$(git_prompt)%(!.%F{167}#%f.%F{108}$%f) '
    '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = "${inputs.plugin-zsh-autosuggestions}";
      }
      {
        name = "zsh-syntax-highlighting";
        src = "${inputs.plugin-zsh-syntax-highlighting}";
      }
    ];
  };
}
