{ config, lib, pkgs, ... }:

let
  cfg = config.t3ra.zsh;

  # Helper to get content from string or path
  getContent = content:
    if builtins.isPath content then builtins.readFile content
    else content;

  # Default .zshrc content
  defaultZshrc = builtins.readFile ./default.zshrc;
in
{
  imports = [
    ./interface.nix
  ];

  config = lib.mkIf cfg.enable (
    let
      # Get base package with selected extensions
      basePackage = pkgs.t3ra.zsh-with cfg.enabledExtensions;

      # Determine actual config content
      configContent = if cfg.config != null then getContent cfg.config else defaultZshrc;

      # Create an enhanced package that includes custom config if provided
      enhancedPackage = pkgs.runCommand "t3ra-zsh-configured"
        {
          # Preserve metadata from base package
          meta = basePackage.meta or { };
        } ''
        mkdir -p $out
        # Copy all files including hidden ones (dotfiles)
        cp -r ${basePackage}/. $out/
        chmod -R +w $out

        # Override .zshrc with config content
        cat > $out/.zshrc << 'EOF'
${configContent}
EOF
      '';

      # Generate shell hook for mkShell integration
      shellHookText = ''
        # Source extension environment variables from package
        source ${enhancedPackage}/extensions.sh
        export ZDOTDIR="${enhancedPackage}"

        # Auto-start zsh if in interactive shell
        if [ -n "$PS1" ] && [ -z "$ZSH_EXECUTION_STRING" ]; then
          exec ${pkgs.zsh}/bin/zsh
        fi
      '';
    in
    {
      # Set the read-only options
      t3ra.zsh.package = enhancedPackage;
      t3ra.zsh.shellHook = shellHookText;

      # Add packages to the environment
      packages = [ enhancedPackage pkgs.zsh ];

      # Set ZDOTDIR environment variable
      env = [{
        name = "ZDOTDIR";
        value = "${enhancedPackage}";
      }];
    }
  );
}
