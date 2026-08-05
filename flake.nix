{
  description = "T3RA's collection of Nix packages and utilities";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      lib = nixpkgs.lib;

      # Merge selected nushell module packages into one flat directory
      # ($out/<name> per module) so a single $env.NU_LIB_DIRS entry sees all
      # of them. Flat, not `buildNupmPackage`'s own `$out/modules/<name>`
      # layout, so a module can `use ../sibling` - a real relative path - to
      # reach another enabled module. `cp -r` rather than symlinks, so that
      # resolves regardless of whether Nushell follows symlinks when
      # resolving relative `use` paths.
      mkNushellModules = pkgs: enabledModules:
        pkgs.runCommand "t3ra-nushell-modules" { } (
          "mkdir -p $out\n"
          + lib.concatMapStringsSep "\n"
            (m: "cp -r ${pkgs.t3ra.${m}}/modules/${m} $out/${m}")
            enabledModules
        );
    in
    {
      # Overlay to add t3rapkgs to nixpkgs
      overlays.default = final: prev: {
        t3ra = {
          # Build support: turn a nupm-format package into a Nix derivation
          buildNupmPackage = final.callPackage ./pkgs/build-support/build-nupm-package { };

          # Individual nushell modules. Source is fetched straight from
          # t3ra-oss/nupkgs (a plain nupm package repo with no Nix of its
          # own knowledge required here) via fetchFromGitHub, same as any
          # nixpkgs package pulls in its upstream source - t3rapkgs never
          # depends on nupkgs's flake, so there's no dependency cycle even
          # though nupkgs may optionally depend on t3rapkgs for its own,
          # separate self-build convenience.
          git = final.callPackage ./pkgs/git { inherit (final.t3ra) buildNupmPackage; };
          moon = final.callPackage ./pkgs/moon { inherit (final.t3ra) buildNupmPackage; };
          kubectl = final.callPackage ./pkgs/kubectl { inherit (final.t3ra) buildNupmPackage; };

          # Default package with all modules
          nushell-modules = mkNushellModules final [ "git" "moon" "kubectl" ];

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
          git = pkgs.t3ra.git;
          moon = pkgs.t3ra.moon;
          kubectl = pkgs.t3ra.kubectl;
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
