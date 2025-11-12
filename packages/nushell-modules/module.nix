{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.t3ra.nushell-modules;
  
  # Available module options
  moduleOptions = [ "git" "halp" "moon" "kubectl"];
in
{
  options.t3ra.nushell-modules = {
    enable = mkEnableOption "T3RA nushell modules";

    enabledModules = mkOption {
      type = types.listOf (types.enum moduleOptions);
      default = [ "git" ]; # All modules by default
      example = [ "git" "halp" ];
      description = ''
        List of nushell modules to include. Available modules: ${concatStringsSep ", " moduleOptions}
      '';
    };

    package = mkOption {
      type = types.package;
      readOnly = true;
      description = "The configured nushell-modules package";
    };

    config = mkOption {
      type = types.nullOr (types.either types.str types.path);
      default = null;
      example = ''
        $env.config = {
          show_banner: false
          edit_mode: vi
        }
      '';
      description = "Nushell config.nu content (string) or path to config file. If null, no config is used.";
    };

    init = mkOption {
      type = types.either types.str types.path;
      default = concatMapStringsSep "\n" (module: "overlay use ${module}/overlay.nu as ${module}") cfg.enabledModules;
      example = ''
        overlay use git/overlay.nu as git
        overlay use halp/overlay.nu as halp
      '';
      description = "Nushell init.nu content (string) or path to init file. Defaults to activating enabled module overlays.";
    };

    startupText = mkOption {
      type = types.str;
      readOnly = true;
      description = "Startup text for numtide devshell to launch nushell with configured modules";
    };
  };

  config = mkIf cfg.enable (let
    basePackage = pkgs.t3ra.nushell-modules-with cfg.enabledModules;
    
    # Helper to handle string vs file input
    getContent = input: if isString input then input else readFile input;
    
    # Create enhanced package with config files
    enhancedPackage = pkgs.runCommand "t3ra-nushell-modules-configured" {} ''
      mkdir -p $out
      cp -r ${basePackage}/* $out/
      
      # Create init.nu
      cat > $out/init.nu << 'EOF'
${getContent cfg.init}
EOF

      ${optionalString (cfg.config != null) ''
        # Create config.nu if provided
        cat > $out/config.nu << 'EOF'
${getContent cfg.config}
EOF
      ''}
    '';
    
    # Generate startup text for numtide devshell
    startupCmd = "exec nu" + 
      (optionalString (cfg.config != null) " --config ${enhancedPackage}/config.nu") +
      " -e \"source ${enhancedPackage}/init.nu\"";
      
  in {
    t3ra.nushell-modules.package = enhancedPackage;
    t3ra.nushell-modules.startupText = startupCmd;

    # Add the configured modules directly to packages so they're available in shell
    # Include nushell when startup is configured (since we need it to execute)
    packages = [ enhancedPackage pkgs.nushell ];

    # Add modules to nushell library path
    env = [
      {
        name = "NU_LIB_DIRS";
        value = "${enhancedPackage}";
      }
    ];
  });
}
