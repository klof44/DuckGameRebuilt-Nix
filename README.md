# DuckGameRebuilt-Nix

Experimental flake for installing [Duck Game Rebuilt](https://github.com/TheFlyingFoool/DuckGameRebuilt)  
  
>[!IMPORTANT]
>Duck Game Rebuilt is not launched with steam when running natively;
>You need to start the game BEFORE clicking invite links

## Installation

Add the input to your flake

```nix
# flake.nix
{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # ... other inputs

        DuckGameRebuilt = {
            url = "github:klof44/DuckGameRebuilt-Nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = inputs@{ nixpkgs, home-manager /* if using home-manager */, ... }: {
        nixosConfigurations.<HOSTNAME> = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            # For home-manager
            modules = [
                # ... configuration.nix etc.

                home-manager.nixosModules.home-manager {
                    home-manager {
                        # ... user, imports, etc.
                        extraSpecialArgs = { inherit inputs; }; # <-----
                    }
                }
            ]

            ### OR ###

            # For System Installation
            specialArgs = { inherit inputs; };
        };
    };
}
```

Add the package to your system

```nix
# home-manager (home.nix)
home.packages = with pkgs; {
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
};

### OR ###

# NixOS system (configuration.nix)
environment.systemPackages = with pkgs; {
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
};
```
