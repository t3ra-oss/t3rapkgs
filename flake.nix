{
  description = "T3RA's collection of Nix packages and utilities";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    {
      # Overlay to add t3rapkgs to nixpkgs
      overlays.default = final: prev: {
        t3ra = {
          # Default package with all modules
          nushell-modules = final.callPackage ./packages/nushell-modules { };
          
          # Configurable package function
          nushell-modules-with = enabledModules: 
            final.callPackage ./packages/nushell-modules { inherit enabledModules; };
          
          # Future packages go here:
          # another-tool = final.callPackage ./packages/another-tool { };
        };
      };

      # Module for configuration (imports all, enables nothing by default)
      nixosModules = {
        default = { imports = [ ./packages/nushell-modules/module.nix ]; };
        nushell-modules = ./packages/nushell-modules/module.nix;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ 
            devshell.overlays.default
            self.overlays.default 
          ];
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          nushell-modules = pkgs.t3ra.nushell-modules;
          # Future packages go here:
          # another-tool = pkgs.t3ra.another-tool;
          
          # Make nushell-modules the default for now
          default = self.packages.${system}.nushell-modules;
        };

        # Development shell for this repository
        devShells.default = pkgs.devshell.mkShell ({ config, ... }: {
          imports = [ self.nixosModules.nushell-modules ];
          
          t3ra.nushell-modules = {
            enable = true;
            enabledModules = [ "git" ];
          };

          packages = with pkgs; [
            nixpkgs-fmt
            nix-tree
          ];
          
          devshell.startup."100-nushell".text = config.t3ra.nushell-modules.startupText;
        });
      });
}
