{ lib }:

{
  # Create standardized T3RA dev shells
  #
  # Arguments:
  #   pkgs: The nixpkgs instance with overlays applied
  #   system: The system architecture (for apps output)
  #   name: Base name of the project (e.g., "MyProject")
  #   packages: List of packages to include in all shells
  #   env: Additional environment variables (list of { name, value/eval })
  #   commands: Additional commands configuration
  #   defaultShell: Which shell type to use as default - "bare", "zsh", or "nu" (default: "zsh")
  #   monorepo: If true, adds moon to packages and enables moon nushell module (default: false)
  #   shell.nu.config: Path to nushell config.nu file or content (optional)
  #   shell.zsh.config: Path to zsh .zshrc file or content (optional)
  mkDevShells = {
    pkgs,
    system,
    name,
    packages ? [],
    env ? [],
    commands ? [],
    defaultShell ? "zsh",
    monorepo ? false,
    shell ? {},
  }:
    let
      # Helper to check if a package is in the list
      hasPackage = pkgName: builtins.any (pkg: pkg.pname or pkg.name or "" == pkgName) packages;

      # Auto-detect which nushell modules to enable based on packages
      autoNushellModules =
        [ "git" "halp" ] # Always include git and halp
        ++ (lib.optional (monorepo || hasPackage "moon") "moon");

      # Add moon package if monorepo is enabled
      finalPackages = packages ++ (lib.optional monorepo pkgs.moon);

      # Standard T3RA environment variables
      t3raEnv = [
        {
          name = "PRJ_ROOT";
          eval = "$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)";
        }
        {
          name = "XDG_CACHE_DIR";
          eval = "$PRJ_ROOT/.cache";
        }
      ] ++ (lib.optional monorepo {
        name = "MOON_WORKSPACE_ROOT";
        eval = "$PRJ_ROOT";
      });

      # Base configuration with T3RA standards
      baseConfig = {
        inherit commands;
        env = t3raEnv ++ env;
      };

      # Merge function that handles both simple attrs and functions
      mergeShellConfig =
        base: override: args:
        let
          overrideAttrs = if builtins.isFunction override then override args else override;
        in
        base // overrideAttrs;

      # Common shell creator
      makeShell = moduleOrAttrs:
        pkgs.devshell.mkShell (mergeShellConfig baseConfig moduleOrAttrs);

      # Bare shell (minimal, for CI/LLMs)
      bareShell = makeShell {
        name = "${name}[Bare]";
        packages = finalPackages;
      };

      # ZSH shell (interactive development)
      # Note: We need config parameter to access the evaluated module options
      zshShell = makeShell ({ config, ... }: {
        name = "${name}[zsh]";

        # Reference the zsh module directly from t3rapkgs
        imports = [ ../../modules/zsh ];

        packages = finalPackages;

        t3ra.zsh = {
          enable = true;
        } // lib.optionalAttrs (shell ? zsh) shell.zsh;

        devshell.startup."100-zsh".text = config.t3ra.zsh.shellHook;
      });

      # Nushell shell (for chad devs)
      # Note: We need config parameter to access the evaluated module options
      nuShell = makeShell ({ config, ... }: {
        name = "${name}[nu]";

        # Reference the nushell-modules module directly from t3rapkgs
        imports = [ ../../modules/nushell-modules ];

        packages = finalPackages ++ [
          pkgs.nushell
          pkgs.vivid
          pkgs.carapace
          pkgs.starship
        ];

        t3ra.nushell-modules = {
          enable = true;
          enabledModules = autoNushellModules;
        } // lib.optionalAttrs (shell ? nu) shell.nu;

        devshell.startup."100-nushell".text = config.t3ra.nushell-modules.shellHook;
      });

      # Map shell type to shell
      shellMap = {
        bare = bareShell;
        zsh = zshShell;
        nu = nuShell;
      };

      # Validate defaultShell
      selectedDefault = shellMap.${defaultShell} or (throw "Unknown defaultShell: ${defaultShell}. Must be one of: bare, zsh, nu");

    in {
      # Dev shells
      devShells = {
        default = selectedDefault;
        bare = bareShell;
        zsh = zshShell;
        nu = nuShell;
      };

      # App to run devshell commands
      apps.default = {
        type = "app";
        program = "${bareShell.flakeApp.program}";
      };
    };
}
