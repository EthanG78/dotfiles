{
    description = "NixOS (ethang) Laptop Flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in {
            nixosConfigurations = {
                ethang-lp = nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {inherit inputs;};
                    modules = [
                        ./configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.ethang = import ./home.nix;
                            home-manager.backupFileExtension = "backup";
                        }
                    ];
                };
            };
        };
}

