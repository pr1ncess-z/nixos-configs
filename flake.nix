{
  description = "NixOS for pr1ncess";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    pi.url = "github:lukasl-dev/pi.nix";
    nix-alien.url = "github:thiagokokada/nix-alien";
    ssbm-nix.url = "github:djanatyn/ssbm-nix";
    
    nixvim = {
     url = "github:nix-community/nixvim";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    cachyos-settings = {
      url = "github:Daaboulex/cachyos-settings-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*-- zsh --*/
    plugin-zsh-autosuggestions = {
      url = "github:zsh-users/zsh-autosuggestions";
      flake = false;
    };
    plugin-zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, nix-cachyos-kernel, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.nixos-durian = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; }; # This passes `inputs` to configuration.nix
      modules = [
        (
          { pkgs, inputs, ... }:
            {
              nixpkgs.overlays = [
                # Use the exact nixpkgs revision as defined in this repo to ensure binary cache hits.
                nix-cachyos-kernel.overlays.pinned

                # Alternatively, use nixpkgs from your environment, nixpkgs.config will apply.
                # Note: may not hit binary cache; kernel will need to be built locally.
                # nix-cachyos-kernel.overlays.default

                # Only use one of the two overlays!

                # dolphin-overlay.overlays.default
                inputs.pi.overlays.default

                inputs.nix-alien.overlays.default
                # (final: prev: {
                #   mbedtls_2 = final.mbedtls;
                #   webkitgtk = final.webkitgtk_4_1;
                #   wrapGAppsHook = final.wrapGAppsHook3;
                # }) 
                # inputs.ssbm-nix.overlay
              ];
            }
        )

        ./hosts/durian/configuration.nix
        ./hosts/durian/hardware-configuration.nix
        ./modules/gaming.nix
        ./users/will/nixos.nix

        chaotic.nixosModules.default
        inputs.cachyos-settings.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.will = import ./users/will/home.nix;
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
      "https://attic.xuyh0120.win/lantian"
      "https://noctalia.cachix.org"
      "https://pi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
    ];
  };
}
