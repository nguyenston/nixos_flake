{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = input@{ self, nixpkgs, home-manager, hyprland, ... }:
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
