{
  description = "NixOS pr1ncess";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    cachyos-settings = {
    	url = "github:Daaboulex/cachyos-settings-nix";
    	inputs.nixpkgs.follows = "nixpkgs";
    }

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, ... }@inputs:
  {
    nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # This passes `inputs` to configuration.nix
      modules = [
        ./hardware-configuration.nix
        ./gaming.nix
        ./configuration.nix
        
        chaotic.nixosModules.default
        inputs.cachyos-settings.nixosModules.default
        
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.will = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://nyx-cache.chaotic.cx/"
      "https://chaotic-nyx.cachix.org"
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
	    "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
	    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
