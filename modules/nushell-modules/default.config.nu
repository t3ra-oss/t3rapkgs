use std/util "path add"

path add $"($env.HOME)/.nix-profile/bin"
path add $"/etc/profiles/per-user/($env.USER)/bin"

# Theming
$env.LS_COLORS = (vivid generate ayu | str trim)
$env.config.table.mode = "markdown"
$env.config.show_banner = false

# Completions
let carapace_completer = {|spans|
  let spans = $spans | skip 1 | prepend (
    scope aliases | where name == $spans.0 | # Find potential alias
      append {expansion: $spans.0} | # Default to original command
      get expansion | first | split words # Get expanded version
  )

  carapace $spans.0 nushell ...$spans | from json
}

$env.config.completions = {
  case_sensitive: false
  quick: true
  partial: true
  algorithm: "fuzzy"
  external: {
    enable: true
    max_results: 100
    completer: $carapace_completer
  }
}

$env.config.edit_mode = 'vi'
$env.config.menus = [
  {
    name: history_menu
    only_buffer_difference: true
    marker: " "
    type: {
      layout: list
      page_size: 10
    }
    style: {
      text: purple
      selected_text: purple_reverse
      description_text: yellow
    }
  }
]

# Configure starship
$env.STARSHIP_CONFIG = ($nu.config-path | path dirname | path join starship.toml)
$env.STARSHIP_SHELL = "nu";
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
$env.PROMPT_MULTILINE_INDICATOR = (starship prompt --continuation)
$env.PROMPT_COMMAND = { || (
   starship prompt
    --cmd-duration $env.CMD_DURATION_MS
    $'--status=($env.LAST_EXIT_CODE)'
    --terminal-width (term size).columns
)}
$env.PROMPT_COMMAND_RIGHT = { || (
   starship prompt
    --right
    --cmd-duration $env.CMD_DURATION_MS
    $'--status=($env.LAST_EXIT_CODE)'
    --terminal-width (term size).columns
)}
$env.config.render_right_prompt_on_last_line = true

$env.config.hooks.env_change.PWD = [
  {
    condition: {|before, after|
      match $before {
        null | nothing | "" => ($after | path join "moon.yml" | path exists),
        _ => ((not ($before | path expand | str starts-with ($after | path expand))) and ($after | path join "moon.yml" | path exists))
      }
    }
    code: {|before, after| $after | path join "moon.yml" | open | get -o id | default ($after | path basename) | moon project $in}
  }
]

alias cat = open --raw
alias :q = exit
