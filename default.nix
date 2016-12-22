with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name;
                  paths = buildInputs; };

  buildInputs = [
    python35
    python35Packages.jupyter
    ];
}
