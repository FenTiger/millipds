{ pkgs ? import <nixpkgs> {} }:

rec {
  inherit (pkgs) callPackage;

  dag-cbrrr = callPackage ./dag-cbrrr.nix { inherit pkgs; };
  atmst = callPackage ./atmst.nix { inherit pkgs dag-cbrrr; };
}
