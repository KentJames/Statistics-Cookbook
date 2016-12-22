## Overview

This is a way of teaching myself Bayesian statistics, as someone who hasn't encountered it much before. It is part of the general background to my PhD topic, but I am hoping that by setting out each notebook with a different theme(single parameter vs max entropy etc) I can have it as a nice reference for the future!

## Nix

This should run in a jupyter notebook with the standard python kernel, as well as the R kernel. I want to add the haskell kernel, but the cannibalised .nix I used unfortunately fails to build the haskell kernel.

To run with all kernels(R and python for now):

`nix-shell jupyter-all.nix`

R Notebook:

`nix-shell jupyter-r.nix`

Standard Python Notebook:

`nix-shell`




