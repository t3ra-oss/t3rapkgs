{
  description = "T3RA's collection of Nix packages and utilities";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nupkgs.url = "github:t3ra-oss/nupkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nupkgs }:
    let
      lib = nixpkgs.lib;

      # Merge selected nupkgs nushell modules into one flat directory
      # ($out/<name> per module) so a single $env.NU_LIB_DIRS entry sees all
      # of them. Flat, not `nupkgs`'s own `$out/modules/<name>` layout,
      # because `halp/mod.nu` does `use ../moon` - a real relative path that
      # only resolves when `halp` and `moon` are siblings on disk. `cp -r`
      # rather than symlinks, so that resolves regardless of whether Nushell
      # follows symlinks when resolving relative `use` paths.
      mkNushellModules = pkgs: enabledModules:
        let
          nuPkgs = nupkgs.packages.${pkgs.system};
        in
        pkgs.runCommand "t3ra-nushell-modules" { } (
          "mkdir -p $out\n"
          + lib.concatMapStringsSep "\n"
            (m: "cp -r ${nuPkgs.${m}}/modules/${m} $out/${m}")
            enabledModules
        );
    in
    {
      # Library functions (similar to flake-utils.lib)
      lib.devshell = import ./lib/devshell { inherit lib; };

      # Overlay to add t3rapkgs to nixpkgs
      overlays.default = final: prev: {
        t3ra = {
          # Default package with all modules
          nushell-modules = mkNushellModules final [ "git" "halp" "moon" "kubectl" ];

          # Configurable package function for selective module installation
          nushell-modules-with = enabledModules: mkNushellModules final enabledModules;

          # Default zsh package with default extensions
          zsh = final.callPackage ./pkgs/zsh { };

          # Configurable package function for selective extension installation
          zsh-with = enabledExtensions:
            final.callPackage ./pkgs/zsh { inherit enabledExtensions; };
        };
      };

      # NixOS modules for configuration
      nixosModules = {
        nushell-modules = ./modules/nushell-modules;
        zsh = ./modules/zsh;
        default = {
          imports = [
            self.nixosModules.nushell-modules
            self.nixosModules.zsh
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        # Per-system outputs
        packages = {
          nushell-modules = pkgs.t3ra.nushell-modules;
          zsh = pkgs.t3ra.zsh;

          # Make nushell-modules the default for now
          default = pkgs.t3ra.nushell-modules;
        };

        # Development shell for this repository
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            nix-tree
            nushell
          ];

          shellHook = ''
            export NU_LIB_DIRS="${pkgs.t3ra.nushell-modules}"
          '';
        };
      });
}
