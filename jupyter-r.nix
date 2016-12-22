# Usage: nix-shell --run "jupyter notebook"
with import <nixpkgs> {};
let dependencies = rec {
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
    ];
  };
  R_kernel = stdenv.mkDerivation rec {
    name = "ir";
    buildInputs = [ R ];
    json = builtins.toJSON {
      argv = [ "${R}/bin/R"
               "--slave" "-e" "IRkernel::main()"
               "--args" "{connection_file}" ];
      display_name = "R";
      language = "R";
    };
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out
      cat > $out/kernel.json << EOF
      $json
      EOF
    '';
  };

  jupyter_config_dir = stdenv.mkDerivation {
    name = "jupyter";
    buildInputs = [
      R_kernel
    
    ];
    builder = writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/kernels $out/migrated
      ln -s ${R_kernel} $out/kernels/${R_kernel.name}
      cat > $out/jupyter_notebook_config.py << EOF
      c.KernelSpecManager.whitelist = {
        '${R_kernel.name}'
      }
      EOF
    '';
  };
};
in with dependencies;
stdenv.mkDerivation rec {
  name = "jupyter";
  buildInputs = [
    python35Packages.jupyter
    jupyter_config_dir
  ];
  shellHook = ''
    mkdir -p $PWD/.jupyter
    export JUPYTER_PATH=${jupyter_config_dir}
    export JUPYTER_CONFIG_DIR=${jupyter_config_dir}
    export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
    export JUPYTER_DATA_DIR=$PWD/.jupyter
  '';
}
