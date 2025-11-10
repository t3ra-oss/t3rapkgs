export use curr.nu
export use comp.nu *

def "nu-complete moon pid" [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (^moon query projects --json | from json | get projects | select -o id config.project.description | rename value description)
  }
}

# CD to a moon project root directory.
export def --env cd [
  pid?: string@"nu-complete moon pid"
] {
  alias builtin_cd = cd

  let dir = match $pid {
    null => $env.PRJ_ROOT
    _ => ( ^moon project $pid --json | from json | get root )
  }
  
  builtin_cd $dir
}
