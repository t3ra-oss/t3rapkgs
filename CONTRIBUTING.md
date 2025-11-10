# Contributing to T3RAPKGS

Thank you for your interest in contributing to T3RAPKGS! This guide will help you get started with contributing to our collection of Nix packages and utilities.

## Development Setup

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Git
- Basic familiarity with Nix expressions and the Nix ecosystem

### Getting Started

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/t3rapkgs.git
   cd t3rapkgs
   ```

2. **Enter Development Environment**
   ```bash
   nix develop
   ```
   This provides you with `nixpkgs-fmt` for formatting and `nix-tree` for dependency exploration.

3. **Verify Setup**
   ```bash
   nix flake check
   nix build
   ```

## Project Structure

```
t3rapkgs/
├── flake.nix              # Main flake configuration
├── packages/              # Package definitions
│   └── nushell-modules/   # Nushell modules package
│       ├── default.nix    # Package definition
│       ├── module.nix     # NixOS module
│       └── modules/       # Individual modules
│           ├── git/       # Git utilities
│           ├── halp/      # Help tools
│           └── moon/      # Moon utilities
├── README.md
└── CONTRIBUTING.md
```

## Adding New Packages

### 1. Create Package Directory

```bash
mkdir -p packages/your-package-name
```

### 2. Write Package Definition

Create `packages/your-package-name/default.nix`:

```nix
{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "your-package-name";
  version = "1.0.0";
  
  src = ./src; # or fetchFromGitHub, etc.
  
  # Add build instructions here
  
  meta = with lib; {
    description = "Brief description of your package";
    homepage = "https://github.com/t3ra-oss/t3rapkgs";
    license = licenses.mit;
    maintainers = [ "your-email@example.com" ];
    platforms = platforms.all; # or specific platforms
  };
}
```

### 3. Update Main Flake

Add your package to `flake.nix`:

```nix
# In the overlay section
overlays.default = final: prev: {
  t3ra = {
    nushell-modules = final.callPackage ./packages/nushell-modules { };
    nushell-modules-with = enabledModules: 
      final.callPackage ./packages/nushell-modules { inherit enabledModules; };
    
    # Add your package here:
    your-package-name = final.callPackage ./packages/your-package-name { };
  };
};

# In the packages section
packages = {
  nushell-modules = pkgs.t3ra.nushell-modules;
  # Add your package here:
  your-package-name = pkgs.t3ra.your-package-name;
  
  default = self.packages.${system}.nushell-modules; # Update if needed
};
```

## Adding Nushell Modules

### 1. Create Module Directory

```bash
mkdir -p packages/nushell-modules/modules/your-module
```

### 2. Create Module Files

- `mod.nu` - Main module file with exported functions
- `overlay.nu` - Command overlays (optional)
- Additional `.nu` files as needed

### 3. Update Module List

Add your module to the `allModules` list in `packages/nushell-modules/default.nix`:

```nix
allModules = [ "git" "halp" "moon" "your-module" ];
```

## Code Standards

### Nix Code Style

- **Formatting**: Use `nixpkgs-fmt` for consistent formatting
  ```bash
  nix develop -c nixpkgs-fmt .
  ```

- **Naming**: Use kebab-case for package names and attributes
- **Documentation**: Include comprehensive `meta` attributes
- **Licenses**: Ensure all packages have appropriate license information

### Nushell Module Standards

- **Documentation**: Include help text for all exported functions
- **Naming**: Use clear, descriptive function names
- **Error Handling**: Provide meaningful error messages
- **Testing**: Include examples in docstrings

## Testing

### Build Testing

```bash
# Test flake configuration
nix flake check

# Build specific packages
nix build .#your-package-name

# Test in clean environment
nix build --no-link
```

### Integration Testing

```bash
# Test overlay integration
nix-instantiate --eval -E '
  let
    flake = builtins.getFlake (toString ./.);
    pkgs = import <nixpkgs> { overlays = [ flake.overlays.default ]; };
  in
  pkgs.t3ra.your-package-name.pname
'
```

## Submitting Changes

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Follow the code standards above
   - Add/update tests as needed
   - Update documentation

3. **Test Changes**
   ```bash
   nix flake check
   nix develop -c nixpkgs-fmt .
   nix build
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Format

Use conventional commits:

- `feat:` - New features
- `fix:` - Bug fixes  
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks

### PR Requirements

- [ ] All checks pass (`nix flake check`)
- [ ] Code is properly formatted (`nixpkgs-fmt`)
- [ ] Documentation is updated (README.md if needed)
- [ ] Commit messages follow conventional format
- [ ] PR description explains the changes clearly

## Getting Help

- **Issues**: Open an issue for bugs, feature requests, or questions
- **Discussions**: Use GitHub Discussions for general questions
- **Documentation**: Refer to the [Nix manual](https://nixos.org/manual/nix/) for Nix-specific help

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and contribute
- Follow the project's technical standards

## Maintainers

Current maintainers:
- bastien@t3ra.cloud

Thank you for contributing to T3RAPKGS! 🎉