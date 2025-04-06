{ lib, buildPythonPackage, python3Packages, upstream }:

with python3Packages;

buildPythonPackage rec {
  pname = "millipds";
  version = "0.0.1";
  format = "pyproject";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./src
      ./pyproject.toml
    ];
  };

  buildInputs = [
    aiodns
    aiohttp
    aiohttp-middlewares
    apsw
    argon2-cffi
    base58
    cryptography
    docopt
    pyjwt
    setuptools
    setuptools-scm
    upstream.atmst
    upstream.dag-cbrrr
  ];
}
