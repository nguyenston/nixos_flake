{
  description = "My Awesome Desktop Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ags,
      astal,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "ags-bar";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = with pkgs; [
          wrapGAppsHook3
          gobject-introspection
          ags.packages.${system}.default
        ];

        buildInputs = [
          pkgs.glib
          pkgs.gjs

          # Core Astal libraries
          astal.packages.${system}.io
          astal.packages.${system}.astal3 # GTK3 support

          # Your required Astal libraries (moved from ags.packages to astal.packages)
          astal.packages.${system}.battery
          astal.packages.${system}.bluetooth
          astal.packages.${system}.tray
          astal.packages.${system}.wireplumber
          astal.packages.${system}.network
          astal.packages.${system}.mpris
          astal.packages.${system}.apps
          astal.packages.${system}.notifd
        ];

        installPhase = ''
          mkdir -p $out/bin
          ags bundle app.ts $out/bin/ags-bar --gtk 3
        '';

        preFixup = ''
          gappsWrapperArgs+=(
            --prefix PATH : ${
              pkgs.lib.makeBinPath [
                # Add any runtime executables you need
                # e.g., pkgs.brightnessctl if used
              ]
            }
          )
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          # agsFull includes AGS + all Astal libraries
          ags.packages.${system}.agsFull
        ];
      };
    };
}
