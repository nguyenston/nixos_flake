{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "caps2esc";
  version = "1.0";

  src = pkgs.fetchgit {
    url = "https://gitlab.com/interception/linux/plugins/caps2esc";
    rev = "6ad00311380254ce6c879f08456238c52b5f44c8";
    sha256 = "sha256-cTq0GHD1DqqhM5KwBWlzX+18+B9ULWiDeuPWVKnuZO0=";
  };

  buildInputs = with pkgs; [
    gcc

    git
    cairo
    pango
    libjpeg

    cmake
    ninja
    pkg-config
    gnumake
    interception-tools
  ];

  dontUseCmakeConfigure = true;
  buildPhase = ''
    cmake -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./build/caps2esc $out/bin
  '';
}
