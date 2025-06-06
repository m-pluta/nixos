{
  outputs = { self, ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
    # This imports a formatter
    imports = [ inputs.treefmt-nix.flakeModule ];

    systems = inputs.nixpkgs.lib.systems.flakeExposed;

    perSystem = { config, ... }: {
      # Formatter settings. run `nix fmt`
      treefmt.config = {
        projectRootFile = "flake.nix";
        flakeFormatter = true;
        flakeCheck = true;
        programs = {
          deadnix.enable = true;
          # This lets you do `# keep sorted start|end` and it keeps the lines sorted on format
          keep-sorted.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
        };
      };
    };

    flake = let inherit (self) outputs; in {
      nixosConfigurations.mikebook = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self inputs outputs; };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          # This is where you'd find a nixos-hardware module for your laptop
          #inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
        ] ++ [
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs; };
              users.mikey = import ./home;
            };
          }
        ] ++ [
          ./hardware
          ./common
          ./nix-settings.nix
        ];
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.ngi0.nixos.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # keep-sorted start
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixos-hardware.url = "github:NixOs/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    # keep-sorted end
  };
}
