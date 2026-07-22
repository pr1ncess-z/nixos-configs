{ pkgs, ... }:

{
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    
    shell = pkgs.zsh;
  };
}
