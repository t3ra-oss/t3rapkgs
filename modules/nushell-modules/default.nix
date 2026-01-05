{ config, lib, pkgs, ... }:

let
  cfg = config.t3ra.nushell-modules;

  # Helper to get content from string or path
  getContent = content:
    if builtins.isPath content then builtins.readFile content
    else content;

  # Default init.nu content based on enabled modules
  defaultInit = lib.concatMapStringsSep "\n"
    (module: "overlay use ${module}/overlay.nu as ${module}")
    cfg.enabledModules;

  # Default config.nu content
  defaultConfig = builtins.readFile ./default.config.nu;
in
{
  imports = [
    ./interface.nix
  ];

  config = lib.mkIf cfg.enable (
    let
      # Get base package with selected modules
      basePackage = pkgs.t3ra.nushell-modules-with cfg.enabledModules;

      # Determine actual init content
      initContent = if cfg.init != null then getContent cfg.init else defaultInit;

      # Determine actual config content
      configContent = if cfg.config != null then getContent cfg.config else defaultConfig;

      # Create an enhanced package that includes config.nu and init.nu
      enhancedPackage = pkgs.runCommand "t3ra-nushell-modules-configured"
        {
          # Preserve metadata from base package
          meta = basePackage.meta or { };
        } ''
        mkdir -p $out
        cp -r ${basePackage}/* $out/

        # Create init.nu with overlay activations
        cat > $out/init.nu << 'EOF'
${initContent}
EOF

        # Create config.nu
        cat > $out/config.nu << 'EOF'
${configContent}
EOF

        # Copy starship.toml
        cp ${./starship.toml} $out/starship.toml
      '';

      # Generate shell hook for mkShell integration
      shellHookText = ''
        export NU_LIB_DIRS="${enhancedPackage}"
        export NUSHELL_CONFIG="${enhancedPackage}/config.nu"
        exec nu --config ${enhancedPackage}/config.nu -e "source ${enhancedPackage}/init.nu"
      '';
    in
    {
      # Set the read-only options
      t3ra.nushell-modules.package = enhancedPackage;
      t3ra.nushell-modules.shellHook = shellHookText;

      # Add packages to the environment
      packages = [ enhancedPackage pkgs.nushell ];

      # Set NU_LIB_DIRS environment variable
      env = [{
        name = "NU_LIB_DIRS";
        value = "${enhancedPackage}";
      }];
    }
  );
}
