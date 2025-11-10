def "nu-complete moon pwd tasks" [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: {
      let pid = main

      ^moon query tasks --json $"project=($pid)" |
        from json |
        get tasks |
        get $pid |
        transpose |
        rename value description |
        update description { get -o description }
    }
  }
}

# Look for moon.yml file from pwd up to project root
def "get-moon" []: nothing -> string {
  let git_root = (git rev-parse --show-toplevel | str trim)
  mut dir = (pwd)

  while $dir != ($git_root | path dirname) {
      let moon_path = ($dir | path join "moon.yml")
      if ($moon_path | path exists) { return $moon_path }
      $dir = ($dir | path dirname)
  }
  ""
}

# Return the project ID within the current directory, recursively looking up.
export def "main" [ ] {
  let mf = get-moon
  if ($mf | is-empty) {
    error make --unspanned {
      msg: "Not in a moon project"
      help: "This command must be run from a moon project source."
    }
  }

  let pid = $mf |
    path dirname |
    path relative-to (git rev-parse  --show-toplevel | str trim) |
    ^moon query projects --json $"projectSource=($in)" |
    from json |
    get projects |
    first |
    get id

    $pid
}

# Disply information about the current project.
export def "info" [] {
  ^moon project (main)
}

# Run a list of task on the current project
export def "run" [
  ...tasks: string@"nu-complete moon pwd tasks" # Tasks to run
] {
  let targets = ($tasks | par-each {$"(main):($in)"})
  ^moon run ...$targets
}

# Run moon check on the current project
export def "check" [] {
  ^moon check (main)
}
