{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/de5448dab58";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake =
        let
          myUserName = "hkmangla";
        in
        {
          # Configurations for Linux (NixOS) machines
          nixosConfigurations = {
            nammamachine = self.nixos-flake.lib.mkLinuxSystem {
              imports = [
                # Your machine's configuration.nix goes here
                ./configuration.nix
                {
                  users.users.${myUserName}.isNormalUser = true;
                }
                # Your home-manager configuration
                self.nixosModules.home-manager
                {
                  home-manager.users.${myUserName} = {
                    # imports = [ self.homeModules.default ];
                    home.stateVersion = "22.11";
                  };
                }
              ];
            };
          };

          homeModules.default = { pkgs, ... }: {
            imports = [
              ./home/starship.nix
              ./home/direnv.nix
            ];
          };
        };

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
