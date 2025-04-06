{ pkgs, dag-cbrrr }:

with pkgs;
with python3Packages;

buildPythonPackage rec {
  pname = "atmst";
  version = "0.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "DavidBuchanan314";
    repo = pname;
    rev = "421a27407ddc843738cfab92a98febc842a5ebaf";
    hash = "sha256-U3HxDiuCv53u/QE2UnQoW53+v9Hd2wmlqQEmruBUY3c=";
  };

  nativeBuildInputs = [
    dag-cbrrr
    lru-dict
    more-itertools
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  doCheck = false;
}
