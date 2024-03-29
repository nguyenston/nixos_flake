{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.11-small";

    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/8da072e94b0347c8124f1fc3ed8ee032b6da9c8b"; # this is here until the pull request is merged
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
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
