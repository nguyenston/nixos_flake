{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.11-small";

    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };
  outputs = inputs @{ self, nixpkgs, home-manager, hyprland, ... }:
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
        specialArgs.inputs = inputs;
        modules = [ 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./configuration.nix 
        ];
      };
    };
    homeConfigurations."${user}@${hostname}" = home-manager.lib.homeManagerConfiguration 
    {
      pkgs = import nixpkgs { inherit system; };
      modules = [ ];
    };
  };
}
