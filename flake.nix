{
  description = "millipds";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix2container.inputs.flake-utils.follows = "flake-utils";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    nix2container.url = "github:nlewo/nix2container";
    nixpkgs.url = "nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, flake-utils, nix2container }:
    let
      version = builtins.substring 0 8 self.lastModifiedDate;

    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in with pkgs; let
        n2c = nix2container.packages.${system}.nix2container;
        upstream = import ./upstream { inherit pkgs; };
        python = pkgs.python3;

        millipds = pkgs.callPackage ./. {
          inherit (pkgs.python3Packages) buildPythonPackage;
          inherit upstream;
        };

        python-pkgs = pp: with pp; [
          aiodns
          aiohttp
          aiohttp-middlewares
          apsw
          argon2-cffi
          base58
          cryptography
          docopt
          lru-dict
          millipds
          more-itertools
          pyjwt
          pytest
          pytest-aio
          pytest-check
          pytest-html
          pyyaml
          upstream.atmst
          upstream.dag-cbrrr
        ];

        python-env = python.withPackages python-pkgs;

        container = n2c.buildImage {
          name = "millipds";
          tag = "build-tmp";
          config = {
            entrypoint = [ "/bin/sh" "-c" ];
            #cmd = [ "millipds init pds.test" ];
            cmd = [ "millipds run --listen_host=0.0.0.0 --listen_port=49080" ];
            labels = {
              "org.opencontainers.image.source" = "https://codeberg.org/FenTiger";
              "org.opencontainers.image.description" = "millipds";
            };
          };
          copyToRoot = [
            (buildEnv {
              name = "root";
              paths = [
                busybox
                cacert
                glibc
                python-env
              ];
              pathsToLink = [ "/bin" "/etc" "/opt" ];
            })
          ];
        };

      in {
        packages = {
          millipds = millipds;
          container = container;
        };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              python-env
            ];

            shellHook = ''
              echo version: ${version}
              export PS1="(millipds) $PS1"
              export PYTHONPATH=`pwd`/src:$PYTHONPATH
            '';
          };
        };
      });
}
