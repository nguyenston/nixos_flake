{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "github:hyprwm/Hyprland";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };
  outputs = input@{ self, nixpkgs, home-manager, hyprland, nix-alien, ... }:
  let
    user = (import ./global-params.nix).user;
    hostname = (import ./global-params.nix).hostname;
    system = (import ./global-params.nix).system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUfree = true;
    };
    lib = nixpkgs.lib;
  in 
  {
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        modules = [ 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              xwayland = {
                enable = true;
              };
            };
          }
          ({ self, system, ...}: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
          })
          ./configuration.nix 
        ];
      };
    };
    homeConfigurations."${user}@${hostname}" = home-manager.lib.homeManagerConfiguration 
    {
      pkgs = nixpkgs.legacyPackages.${system};

      modules = [
        hyprland.homeManagerModules.default
        {
          wayland.windowManager.hyprland.enable = true;
          programs.hyprland = {
            enable = true;
            xwayland = {
              enable = true;
              hidpi = true;
            };
            nvidiaPatches = true;
          };
        }
      ];
    };
  };
}
