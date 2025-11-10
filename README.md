# T3RAPKGS

T3RA's collection of Nix packages and utilities, provided as a Nix overlay for easy integration into your NixOS or Nix environment.

## Features

- **Nushell Modules**: A curated collection of Nushell modules and overlays including:
  - **git**: Git utilities and enhancements
  - **halp**: Help and documentation tools
  - **moon**: Moon-related utilities and completions

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
    };
}
```

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
            enabledModules = [ "git" "halp" ]; # Choose specific modules
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

## Development

### Building Locally

```bash
# Check flake configuration
nix flake check

# Build default package
nix build

# Build specific package
nix build .#nushell-modules

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

### Development Shell with Nushell Modules

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
