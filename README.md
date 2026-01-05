# T3RAPKGS

T3RA's collection of Nix packages and utilities, provided as a Nix overlay for easy integration into your NixOS or Nix environment.

## Features

- **Nushell Modules**: A curated collection of Nushell modules and overlays including:
  - **git**: Git utilities and enhancements
  - **halp**: Help and documentation tools
  - **moon**: Moon project management utilities
  - **kubectl**: Kubernetes command aliases
- **Zsh Configuration**: Pre-configured zsh with oh-my-zsh and popular extensions
- **Devshell Helper**: `lib.devshell.mkDevShells` for creating standardized development shells

## Quick Start

### Using the Overlay in Your Flake

Add t3rapkgs to your flake inputs and apply the overlay:

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
      # Now you can use packages like:
      # pkgs.t3ra.nushell-modules
      # pkgs.t3ra.zsh
    };
}
```

### Using lib.devshell with numtide/devshell

The `lib.devshell.mkDevShells` helper creates standardized development shells with nushell and zsh support. You need to bring your own `devshell` input:

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
          packages = with pkgs; [ nodejs python3 ];
          defaultShell = "nu";  # or "zsh" or "bare"
          monorepo = false;     # set true to enable moon integration
          # Optional: customize shell configurations
          shell = {
            nu = {
              # Override nushell module options
              enabledModules = [ "git" "halp" ];
            };
            zsh = {
              # Override zsh module options
              enabledExtensions = [ "autosuggestions" "syntax-highlighting" ];
            };
          };
        };
      in {
        inherit (shells) devShells apps;
      });
}
```

This creates three shell variants:
- **bare**: Minimal shell for CI/automation
- **zsh**: Interactive zsh with oh-my-zsh and extensions
- **nu**: Nushell with modules, starship prompt, and carapace completions

### NixOS Module Integration

For NixOS users, you can use the provided module for easy configuration:

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    t3rapkgs.url = "github:t3ra-oss/t3rapkgs";
  };

  outputs = { nixpkgs, t3rapkgs, ... }: {
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        t3rapkgs.nixosModules.default
        {
          t3ra.nushell-modules = {
            enable = true;
            enabledModules = [ "git" "halp" ];
          };
          t3ra.zsh = {
            enable = true;
            enabledExtensions = [ "autosuggestions" "syntax-highlighting" ];
          };
        }
      ];
    };
  };
}
```

## Available Packages

### nushell-modules

A collection of Nushell modules that enhance your shell experience.

**Usage:**
```nix
# All modules (default)
pkgs.t3ra.nushell-modules

# Custom selection
pkgs.t3ra.nushell-modules-with [ "git" "moon" ]
```

**Available modules:**
- `git` - Git utilities and workflow enhancements
- `halp` - Help system and documentation tools
- `moon` - Moon project management utilities
- `kubectl` - Kubernetes command aliases

### zsh

Pre-configured zsh with oh-my-zsh and popular extensions.

**Usage:**
```nix
# Default extensions (autosuggestions, syntax-highlighting)
pkgs.t3ra.zsh

# Custom selection
pkgs.t3ra.zsh-with [ "autosuggestions" "syntax-highlighting" "completions" ]
```

**Available extensions:**
- `autosuggestions` - Fish-like autosuggestions
- `syntax-highlighting` - Command syntax highlighting
- `completions` - Additional completions
- `history-substring-search` - History search by substring

## Development

### Building Locally

```bash
# Check flake configuration
nix flake check

# Build default package
nix build

# Build specific package
nix build .#nushell-modules
nix build .#zsh

# Enter development shell
nix develop
```

### Formatting

```bash
# Format all Nix files
nix develop -c nixpkgs-fmt .

# Check formatting without changes
nix develop -c nixpkgs-fmt --check .
```

## Examples

### Simple Development Shell with Nushell Modules

Create a development environment that automatically loads selected nushell modules:

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    t3rapkgs.url = "github:t3ra-oss/t3rapkgs";
  };

  outputs = { nixpkgs, t3rapkgs, ... }: {
    devShells.x86_64-linux.default =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ t3rapkgs.overlays.default ];
        };
      in
      pkgs.mkShell {
        buildInputs = [
          pkgs.nushell
          pkgs.t3ra.nushell-modules
        ];

        shellHook = ''
          export NU_LIB_DIRS="${pkgs.t3ra.nushell-modules}"
        '';
      };
  };
}
```

### Home Manager Integration

Use with Home Manager to enhance your personal shell environment:

```nix
# In your home.nix or similar
{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.NU_LIB_DIRS = ($env.NU_LIB_DIRS | append "${pkgs.t3ra.nushell-modules}")
    '';
  };
}
```

## License

MIT License - see repository for details.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on contributing to this project.
