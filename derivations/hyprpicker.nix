{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "hyprpicker";
  version = "1.0";

  src = pkgs.fetchgit {
    url = "https://github.com/hyprwm/hyprpicker";
    rev = "e4c267292a8b983bf84929fdce01cd2b7513518e";
    sha256 = "sha256-eKkByKfdKkAR79hTs4sk0Bl4dmizbe4DwQo+BCVl5EI=";
  };

  buildInputs = with pkgs; [
    wlroots
    wayland
    wayland-protocols
    gcc

    git
    cairo
    pango
    libjpeg

    cmake
    ninja
    pkg-config
    gnumake
  ];

  dontUseCmakeConfigure = true;
  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./build/hyprpicker $out/bin
  '';
}
