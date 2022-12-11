# Nix project template for [Melange](https://github.com/melange-re/melange)

This template provides all the necessary dependencies (Node, OCaml, Dune...) to develop and run [Melange](https://github.com/melange-re/melange) projects.

## Prerequisites

* Install [Nix package manager with Flake support](https://github.com/mschwaig/howto-install-nix-with-flake-support)

## Build & Run

This will install all the necessary dependencies and activates a bash shell with necessary tooling.
```
nix develop
```

If you prefer a shell other than bash, for example zsh, run
```
nix develop -c zsh
```
After this, the project can be built in the activated shell
```
mel build
```
or via npm
```
npm run build
```

## Activate development shell automatically

* Install [direnv](https://direnv.net/)
* Run `direnv allow` in the project root directory

Development shell will be loaded automatically once you `cd` into the project directory.
It will also unload the configuration when exiting the directory.
