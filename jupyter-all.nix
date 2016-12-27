with import <nixpkgs> {};
let dependencies = rec {
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out
    cat > $out/kernel.json << EOF
    $json
    EOF
  '';

# Cython build is non-functional on macOS currently.
  python35 = pkgs.python35.buildEnv.override {
    extraLibs = with python35Packages; [
      # Kernel
      ipykernel
      ipywidgets
      # Custom packages
#     cython
      matplotlib
      numba
      numpy
#      pandas
      pyfftw
#      scikitimage
#      scikitlearn
      scipy
    ];
  };
  python35_kernel = stdenv.mkDerivation rec {
    name = "python35";
    buildInputs = [ python35 ];
    enableParallelBuilding = true;
    json = builtins.toJSON {
      argv = [ "${python35}/bin/python3.5"
               "-m" "ipykernel" "-f" "{connection_file}" ];
      display_name = "Python 3.5";
      language = "python";
      env = { PYTHONPATH = ""; };
    };
    inherit builder;
  };




#Haskell Kernel will not build on macOS currently. Trying to work out why. 
#Update. Looks like an upstream issue with ihaskell. The ghc-parser build fails specifically.
/*  haskell_kernel = stdenv.mkDerivation rec {
    name = "haskell";
    buildInputs = [ ihaskell ];
    json = builtins.toJSON {
      argv = [ "${ihaskell}/bin/ihaskell"
               "kernel" "{connection_file}"
               "--ghclib" "${ihaskell}/lib/ghc-8.0.1"];
      display_name = "Haskell";
      language = "haskell";
      env = { PATH = "${ihaskell}/bin"; };
    };
    builder = writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out
      ln -s ${ihaskell}/share/*ghc*//*ihaskell*//*html/* $out
      cat > $out/kernel.json << EOF
      $json
      EOF
    '';
  }; */
  R = rWrapper.override {
    packages = with rPackages; [
      # Kernel
      rzmq
      repr
      IRkernel
      IRdisplay
      # Custom packages
      tm
      wordcloud
      LearnBayes
    ];
  };
  R_kernel = stdenv.mkDerivation rec {
    name = "ir";
    buildInputs = [ R ];
    enableParallelBuilding = true;
    json = builtins.toJSON {
      argv = [ "${R}/bin/R"
               "--slave" "-e" "IRkernel::main()"
               "--args" "{connection_file}" ];
      display_name = "R";
      language = "R";
    };
    inherit builder;
  };
  jupyter_config_dir = stdenv.mkDerivation {
    name = "jupyter";
    buildInputs = [
      python35_kernel
  #    haskell_kernel
      R_kernel
    ];
    builder = writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/etc/jupyter/kernels $out/etc/jupyter/migrated
      ln -s ${python35_kernel} $out/etc/jupyter/kernels/${python35_kernel.name}

      ln -s ${R_kernel} $out/etc/jupyter/kernels/${R_kernel.name}
      cat > $out/etc/jupyter/jupyter_notebook_config.py << EOF
      import os
      c.KernelSpecManager.whitelist = {
        '${python35_kernel.name}',

        '${R_kernel.name}'
      }
      EOF
    '';
  };
  #      ln -s ${haskell_kernel} $out/etc/jupyter/kernels/${haskell_kernel.name}
  #         '${haskell_kernel.name}',
};
in with dependencies;
stdenv.mkDerivation rec {
  name = "jupyter";
  env = buildEnv { name = name; paths = buildInputs; };

  buildInputs = [
    python35Packages.jupyter
    jupyter_config_dir
  ];
  enableParallelBuilding = true;
  shellHook = ''
    mkdir -p $PWD/.jupyter
    export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_PATH=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_DATA_DIR=$PWD/.jupyter
    export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
  '';
}