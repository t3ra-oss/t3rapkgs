# T3RA Devshell zsh configuration

# Oh-My-Zsh configuration
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="false"

# Disable oh-my-zsh auto-update and tell it to skip compinit
DISABLE_AUTO_UPDATE="true"

# Plugins
plugins=(
  git
  python
  pip
)

# Source oh-my-zsh
if [ -n "$ZSH" ] && [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# Source zsh plugins from nix packages
if [ -n "$ZSH_AUTOSUGGESTIONS" ] && [ -f "$ZSH_AUTOSUGGESTIONS/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source $ZSH_AUTOSUGGESTIONS/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -n "$ZSH_SYNTAX_HIGHLIGHTING" ] && [ -f "$ZSH_SYNTAX_HIGHLIGHTING/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source $ZSH_SYNTAX_HIGHLIGHTING/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Custom aliases
alias cl=clear

# Custom key bindings
bindkey "^[^M" autosuggest-execute      # Alt+Enter: execute autosuggestion
bindkey "^[?" backward-kill-line        # Alt+?: delete to beginning of line
bindkey "^[[1;3D" backward-word         # Alt+Left: move backward one word
bindkey "^[[1;3C" forward-word          # Alt+Right: move forward one word
bindkey "^BK" beginning-of-line         # Ctrl+B K: move to beginning of line
