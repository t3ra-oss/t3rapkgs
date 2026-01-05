{ lib, ... }:

let
  l = lib // builtins;
  t = l.types;

  # Available extension options (matching zsh-* packages in nixpkgs)
  extensionOptions = [ "autosuggestions" "syntax-highlighting" "completions" "history-substring-search" ];
in
{
  options.t3ra.zsh = {
    enable = l.mkEnableOption "T3RA zsh configuration";

    enabledExtensions = l.mkOption {
      type = t.listOf (t.enum extensionOptions);
      default = [ "autosuggestions" "syntax-highlighting" ];
      description = "List of zsh extensions to include. Available extensions: ${l.concatStringsSep ", " extensionOptions}";
      example = [ "autosuggestions" "syntax-highlighting" "completions" ];
    };

    config = l.mkOption {
      type = t.nullOr (t.either t.str t.path);
      default = null;
      description = ''
        Zsh configuration (.zshrc) content or path to config file.
        Defaults to a sensible T3RA configuration with oh-my-zsh and plugins.
      '';
      example = l.literalExpression ''
        '''
        export ZSH="''${ZSH:-$HOME/.oh-my-zsh}"
        ZSH_THEME="robbyrussell"
        plugins=(git)
        source $ZSH/oh-my-zsh.sh
        '''
      '';
    };

    package = l.mkOption {
      type = t.package;
      readOnly = true;
      description = "The configured zsh package. This is set automatically.";
    };

    shellHook = l.mkOption {
      type = t.str;
      readOnly = true;
      description = ''
        Shell hook text for mkShell integration.
        This is set automatically and can be used in shellHook to launch zsh with the configured settings.
      '';
    };
  };
}
