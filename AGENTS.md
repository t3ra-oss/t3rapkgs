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
│   ├── build-support/
│   │   └── build-nupm-package/  # nupm.nuon -> Nix derivation builder
│   ├── nushell-modules/
│   │   ├── default.nix          # Package definition
│   │   └── modules/             # Nushell module sources
│   │       ├── git/
│   │       ├── halp/
│   │       ├── moon/
│   │       └── kubectl/
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
- `t3ra.buildNupmPackage` - Build support: turns a nupm-format package (a
  directory with `nupm.nuon`) into a Nix derivation, laid out the way nupm's
  own installer would under `$NUPM_HOME` (`$out/modules/<name>` for module
  packages, `$out/scripts` for script packages). Only `type: module` and
  `type: script` are supported; `type: custom` is not. Consumed by
  `t3ra-oss/nupkgs`, which packages T3RA's own nupm modules this way.
- `t3ra.nushell-modules` - All nushell modules (git, halp, moon, kubectl)
- `t3ra.nushell-modules-with` - Function to select specific modules
- `t3ra.zsh` - Zsh with oh-my-zsh and default extensions
- `t3ra.zsh-with` - Function to select specific extensions

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
