def comp_template [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (http get https://www.toptal.com/developers/gitignore/api/list | lines | par-each {split row ','} | flatten)
  }
}

# Generate .gitignore file from topal tempaltes.
export def main [
  --reset (-r) # Replace the current templates in .gitignore
  ...templates: string@comp_template # Templates to add to your gitignore
] {
  if ($templates | is-empty) {
    error make {
      msg: "You must provide at least one template"
      label: {
        text: "Search is empty"
        span: (metadata $templates).span
      }
    }
  }
  mut tpl = $templates

  if ('.gitignore' | path exists) and (not $reset) {
    let existing = open .gitignore | lines | first | if ($in | str index-of "www.toptal.com/developers/gitignore/api") >= 0 { $in | split row '/' | last | split row ','} else {[]}
    $tpl = $tpl | append $existing
  }
  
  http get $"https://www.toptal.com/developers/gitignore/api/($tpl | str join ',')" | save -f .gitignore
}
