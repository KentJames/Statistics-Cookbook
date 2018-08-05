## Overview

This is a collection of jupyter notebooks describing various topics in data science. It's a work in progress however it is my goal to describe some of the common procedures of working with datasets, including free-form analysis, numerical optimisation and fitting techniques such as MCMC, as well as other topics of interest.

## Contents Page

(This will change)

1 - Introduction to basic probability and statistical conventions and concepts.
 - Bayes Formula
 - Introduction to distributions (TODO)
 - Basic linear regression stuff (TODO)
2 - Linear analysis procedures to help understand data before modelling:
 |
  - Principal Component Analysis
  - Singular Value Decomposition (TODO)
  - Eigenvectors/quadrics (TODO)
3 - Markov Chain Monte Carlo
 |
  - Metropolis Hastings
  - Simulated Annealing
4 - Worked Examples
 |
  - Steve Gull's Famous Lighthouse Problem

As I add more things this will change. Would like to look at stuff such as conjugate gradient techniques, nested sampling, hierarchical modelling and clustering etc etc. 


## Contributions

I'd greatly appreciate insight from statisticians/data scientists, as well as any contributions of worked examples from various areas would extremely interesting! I prefer to use raw numpy as much as possible so as not to obfuscate what is going on.

Ultimately I'd like this to be an example led repository for people looking for cookbook statistics techniques, alongside another mathematical material to develop a strong inuitition and learn how data analysis works.

## Dependency Installs

This should run with an out of the bag Jupyter install. I personally use brew, however conda is the best way to get up and going. Dependencies are:

- numpy
- scipy

### Anaconda

By far the easiest way to get going and the _lingua franca_ of python package managers currently is conda:

[Anaconda](https://www.anaconda.com)

### Nix

This should run in a jupyter notebook with the standard python kernel, as well as the R kernel. 

You can install nix, and get a fully functioning build of jupyter up and running by following the instructions below. Nix is great, once you get over its steep learning curve. Alternatively you can configure the R kernel yourself manually.

[Nix: The Purely Functional Package Manager](https://nixos.org/nix/)

To run with all kernels(R and python for now):

```
nix-shell jupyter-all.nix
jupyter notebook
```

R Notebook:

```
nix-shell jupyter-r.nix
jupyter notebook
```

Standard Python Notebook:

```
nix-shell
jupyter notebook
```




