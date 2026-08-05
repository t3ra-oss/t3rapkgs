# CLAUDE.md

This file provides guidance to LLM agents when working with code in this repository.

## Project Overview

This is a Nix flake repository containing T3RA's collection of Nix packages and utilities provided as a Nix overlay.

## Common Commands

### Build and Check
- `nix flake check` - Validate flake configuration and build packages
- `nix build` - Build the default package (nushell-modules)
- `nix build .#nushell-modules` - Build all nushell modules merged
- `nix build .#nu-git` / `.#nu-moon` / `.#nu-kubectl` - Build an individual module
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
├── pkgs/                        # Package definitions (derivations)
│   ├── build-support/
│   │   └── build-nupm-package/  # nupm.nuon -> Nix derivation builder
│   ├── nu-git/
│   │   └── default.nix          # fetchFromGitHub(nupkgs) + buildNupmPackage
│   ├── nu-moon/
│   │   └── default.nix          # same pattern
│   ├── nu-kubectl/
│   │   └── default.nix          # same pattern
│   └── zsh/
│       ├── default.nix          # Package definition
│       └── default.zshrc        # Default zsh configuration
└── modules/                     # NixOS-style configuration modules
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
  `type: script` are supported; `type: custom` is not.
- `t3ra.nu-git`, `t3ra.nu-moon`, `t3ra.nu-kubectl` - Individual nushell
  modules, `nu-` prefixed so they don't read as "the git/moon/kubectl CLI" in
  a repo that also packages unrelated tools (`pname` inside each
  `default.nix` stays the bare name - `"git"`, etc. - since it's checked
  against `nupm.nuon`'s `name` field by `buildNupmPackage`; only the
  top-level attribute is prefixed). Each is `buildNupmPackage` fed a `src`
  fetched straight from [`t3ra-oss/nupkgs`](https://github.com/t3ra-oss/nupkgs)
  via `fetchFromGitHub`, pinned to the `v0.1.0` tag (bump the `rev`/`hash`
  by hand when `nupkgs` cuts a new release) - the same pattern nixpkgs uses
  for e.g. `k9s`
  (`buildGoModule` + `fetchFromGitHub`, source vendored nowhere in-tree).
  `nupkgs` is a plain nupm package repo; this repo never depends on its
  flake, so there is no dependency cycle even though `nupkgs` separately,
  optionally depends on *this* repo to reuse `buildNupmPackage` for its own
  self-build convenience (same as any Go project can use nixpkgs'
  `buildGoModule` in its own flake without nixpkgs ever depending back).
- `t3ra.nushell-modules` - All nushell modules (git, moon, kubectl), merged
  into one flat directory (`$out/<name>` per module, not `buildNupmPackage`'s
  own `$out/modules/<name>`) so a module's `use ../sibling` - a real
  relative path to another enabled module - resolves regardless of which
  subset is selected. Copies files rather than symlinking, for the same
  reason.
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

### Development Environment
The flake provides a simple development shell with:
- `nixpkgs-fmt` for formatting Nix code
- `nix-tree` for exploring package dependencies
- `nushell` with modules available via `$NU_LIB_DIRS`
