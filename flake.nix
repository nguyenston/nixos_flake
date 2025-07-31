{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.11-small";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hypridle = {
    #   url = "github:hyprwm/hypridle";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agsbar = {
      url = "path:ags";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.ags.follows = "ags";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      niri,
      fenix,
      ghostty,
      ...
    }:
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
      packages.${system}.default = fenix.packages.${system}.minimal.toolchain;
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
      homeConfigurations."${user}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ];
      };
    };
}
