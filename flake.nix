{
    description = "Deathlesz' NixOS";

    outputs = inputs @ {self, ...}: let
        # hard-coded for now
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs {
            inherit system;

            config = {allowUnfree = true;};
        };

        pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;

            config = {allowUnfree = true;};
        };

        lib = inputs.nixpkgs.lib;
        libM = lib // import ./lib {lib = lib;};

        # a list of directories inside of `./hosts`
        #                      not null          maps { entryName = "directory", entryName2 = "file" } to [ entryName null ]
        hosts = lib.filter (x: x != null) (lib.mapAttrsToList
        (name: value:
            if (value == "directory")
            then name
            else null)
        (builtins.readDir ./hosts));
    in {
        nixosConfigurations = builtins.listToAttrs (map (host: {
            name = host;
            value = lib.nixosSystem {
                inherit system;

                modules = [
                    # host-specific configuration
                    {config.networking.hostName = host;}
                    ./hosts/${host}

                    # common configuration
                    ./modules/system

                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.backupFileExtension = "hm-backup";

                        home-manager.extraSpecialArgs = {
                            inherit system;
                            inherit pkgs;
                            inherit pkgs-stable;
                            inherit libM;
                            inherit inputs;
                        };
                    }
                ];

                specialArgs = {
                    inherit system;
                    inherit pkgs;
                    inherit pkgs-stable;
                    inherit libM;
                    inherit inputs;
                };
            };
        })
        hosts);
    };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        alejandra = {
            url = "github:kamadorueda/alejandra/4.0.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
