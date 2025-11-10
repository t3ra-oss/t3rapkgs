# AGENTS.md

This file provides guidance to LLM agents when working with code in this repository.

## Project Overview

This is a Nix flake repository containing T3RA's collection of Nix packages and utilities provided as a Nix overlay.

## Common Commands

### Build and Check
- `nix flake check` - Validate flake configuration and build packages
- `nix build` - Build the default package (nushell-overlays)
- `nix build .#nushell-overlays` - Build specific package

### Formatting
- `nix develop -c nixpkgs-fmt .` - Format all .nix files
- `nix develop -c nixpkgs-fmt --check .` - Check formatting without making changes

### Development
- `nix develop` - Enter development shell with nixpkgs-fmt and nix-tree
- `nix flake show` - Show available packages and outputs

## Architecture

The repository follows Nix flake conventions:

### Structure
- `flake.nix` - Main flake configuration with package definitions and development shell
- `packages/` - Individual package directories

### Package System
- Provides packages through a Nix overlay at `overlays.default`
- Packages are accessible under the `t3ra` attribute set (e.g., `pkgs.t3ra.nushell-overlays`)
- Uses `pkgs.callPackage` pattern for package definitions
- Each package has its own `default.nix` with metadata and build instructions
- The nushell-overlays package simply copies source files without compilation

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
      system = "x86_64-linux"; # or your target system
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ t3rapkgs.overlays.default ];
      };
    in {
      # Packages now accessible as pkgs.t3ra.nushell-overlays
    };
}
```

### Development Environment
The flake provides a development shell with:
- `nixpkgs-fmt` for formatting Nix code
- `nix-tree` for exploring package dependencies
