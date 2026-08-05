{ lib, ... }:

let
  l = lib // builtins;
  t = l.types;

  # Available module options
  moduleOptions = [ "git" "moon" "kubectl" ];
in
{
  options.t3ra.nushell-modules = {
    enable = l.mkEnableOption "T3RA nushell modules";

    enabledModules = l.mkOption {
      type = t.listOf (t.enum moduleOptions);
      default = [ "git" ];
      description = "List of nushell modules to include. Available modules: ${l.concatStringsSep ", " moduleOptions}";
      example = [ "git" "moon" ];
    };

    config = l.mkOption {
      type = t.nullOr (t.either t.str t.path);
      default = null;
      description = ''
        Nushell config.nu content or path to config file.
        Defaults to a sensible T3RA configuration with theming, completions, and starship.
      '';
      example = l.literalExpression ''
        '''
        $env.config = {
          show_banner: false
        }
        '''
      '';
    };

    init = l.mkOption {
      type = t.nullOr (t.either t.str t.path);
      default = null;
      description = ''
        Nushell init.nu content or path to init file.
        By default, activates overlays for all enabled modules.
      '';
      example = l.literalExpression ''
        '''
        overlay use git/overlay.nu as git
        overlay use moon/overlay.nu as moon
        '''
      '';
    };

    package = l.mkOption {
      type = t.package;
      readOnly = true;
      description = "The configured nushell-modules package. This is set automatically.";
    };

    shellHook = l.mkOption {
      type = t.str;
      readOnly = true;
      description = ''
        Shell hook text for mkShell integration.
        This is set automatically and can be used in shellHook to launch nushell with the configured modules.
      '';
    };
  };
}
