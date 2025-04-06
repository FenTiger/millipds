{ pkgs }:

with pkgs;
with python3Packages;

buildPythonPackage rec {
  pname = "dag-cbrrr";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "DavidBuchanan314";
    repo = pname;
    rev = "8980ab1b23435ed906dbfa809f25a67091ea1eab";
    hash = "sha256-DKDFINj3MbegnDtDhSHfC0xMK4RCuEDLcfUqAZ7NkT0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  doCheck = false;
}
