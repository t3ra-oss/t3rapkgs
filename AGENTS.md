# CLAUDE.md

This file provides guidance to LLM agents when working with code in this repository.

## Project Overview

This is a Nix flake repository containing T3RA's collection of Nix packages and utilities provided as a Nix overlay.

## Common Commands

### Build and Check
- `nix flake check` - Validate flake configuration and build packages
- `nix build` - Build the default package (nushell-modules)
- `nix build .#nushell-modules` - Build nushell modules package
- `nix build .#zsh` - Build zsh package

### Formatting
- `nix develop -c nixpkgs-fmt .` - Format all .nix files
- `nix develop -c nixpkgs-fmt --check .` - Check formatting without making changes

### Development
- `nix develop` - Enter development shell with nixpkgs-fmt, nix-tree, and nushell
- `nix flake show` - Show available packages and outputs

## Architecture

The repository follows Nix flake conventions:

### Structure
```
t3rapkgs/
├── flake.nix                    # Main flake configuration
├── lib/
│   └── devshell/
│       └── default.nix          # mkDevShells helper for consumers
├── pkgs/                        # Package definitions (derivations)
│   └── zsh/
│       ├── default.nix          # Package definition
│       └── default.zshrc        # Default zsh configuration
└── modules/                     # NixOS/devshell configuration modules
    ├── nushell-modules/
    │   ├── interface.nix        # Module options
    │   ├── default.nix          # Module implementation
    │   ├── default.config.nu    # Default nushell config
    │   └── starship.toml        # Starship prompt config
    └── zsh/
        ├── interface.nix        # Module options
        ├── default.nix          # Module implementation
        └── default.zshrc        # Default zsh config
```

### Package System
- Provides packages through a Nix overlay at `overlays.default`
- Packages are accessible under the `t3ra` attribute set (e.g., `pkgs.t3ra.nushell-modules`)
- Uses `pkgs.callPackage` pattern for package definitions
- Each package has its own `default.nix` with metadata and build instructions

### Available Packages
- `t3ra.nushell-modules` - All nushell modules (git, halp, moon, kubectl),
  merged into one flat directory (`$out/<name>` per module). The actual
  packages live in [`t3ra-oss/nupkgs`](https://github.com/t3ra-oss/nupkgs)
  as real nupm packages (built with nupkgs' own `buildNupmPackage`); this
  repo just re-exports them under the `t3ra` namespace and flattens
  `nupkgs`'s `$out/modules/<name>` layout back to `$out/<name>` for
  backwards compatibility with existing consumers (e.g.
  `modules/nushell-modules`, which assumes a flat layout). `halp/mod.nu`
  does `use ../moon` - a real relative path - so `halp` only works loaded
  alongside `moon`; `nushell-modules` and `nushell-modules-with` copy files
  rather than symlink, so this resolves regardless of enabled module subset.
- `t3ra.nushell-modules-with` - Function to select specific modules
- `t3ra.zsh` - Zsh with oh-my-zsh and default extensions
- `t3ra.zsh-with` - Function to select specific extensions

Note: `buildNupmPackage` itself (nupm.nuon -> Nix derivation) now lives in
`nupkgs`, not here - it belongs with the ecosystem it targets, and keeping
it there avoids a circular flake dependency (this repo depends on `nupkgs`
one-directionally; `nupkgs` depends only on `nixpkgs`).

### Using the Overlay
To use t3rapkgs in another flake:

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    t3rapkgs.url = "github:t3ra-oss/t3rapkgs";
  };

  outputs = { nixpkgs, t3rapkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ t3rapkgs.overlays.default ];
      };
    in {
      # Packages accessible as:
      # - pkgs.t3ra.nushell-modules
      # - pkgs.t3ra.nushell-modules-with [ "git" "moon" ]
      # - pkgs.t3ra.zsh
      # - pkgs.t3ra.zsh-with [ "autosuggestions" "syntax-highlighting" ]
    };
}
```

### Using lib.devshell (for consumers)
The `lib.devshell.mkDevShells` helper creates standardized development shells.
Consumers must bring their own `devshell` input:

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    t3rapkgs.url = "github:t3ra-oss/t3rapkgs";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, t3rapkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlays.default
            t3rapkgs.overlays.default
          ];
        };

        shells = t3rapkgs.lib.devshell.mkDevShells {
          inherit pkgs system;
          name = "MyProject";
          packages = [ pkgs.nodejs ];
          defaultShell = "nu";  # or "zsh" or "bare"
          monorepo = true;      # enables moon integration
        };
      in {
        inherit (shells) devShells apps;
      });
}
```

### Development Environment
The flake provides a simple development shell with:
- `nixpkgs-fmt` for formatting Nix code
- `nix-tree` for exploring package dependencies
- `nushell` with modules available via `$NU_LIB_DIRS`
