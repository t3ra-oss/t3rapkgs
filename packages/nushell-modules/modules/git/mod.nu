# Git Nushell Functions and Aliases

# Description:
# This Nushell script provides a collection of functions and aliases to simplify Git workflows.
# It enforces and encourages the use of Conventional Commits for structured commit messages.
#
# Features:
# - Short aliases for commonly used Git commands.
# - Functions that prompt for Conventional Commit messages.
# - Improved usability for common Git operations.
#
# Conventional Commits Format:
# The script recommends using commit messages in the following format:
#
#   <type>(<scope>): <description>
#
# Examples:
#   feat(ui): add dark mode support
#   fix(api): resolve authentication bug
#   chore(deps): update dependencies
#
# Conventional commit options like types and matching regex can be set
# using the $env.conventional_commit
#
# Usage:
# - Run `scope aliases | where expansion starts-with "git"`` to list available aliases.
# - Use the provided functions to standardize Git commits.
#
# Author: bastien@t3ra.cloud

# Conventional commit module

# Import modules for the current session
export use cc.nu
export use glab.nu
export use ignore.nu

# ghq repo list completion
def "nu-completion repo list" [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (ghq list | lines)
  }
}

# Clean branches that have already been merged
export def "tidy" [] {
  git branch --merged | lines | where ($it != "* master" and $it != "* main") | each {|br| git branch -D ($br | str trim) } | str trim
}

# Ammend last commit with your last changes
export def "redo" [] {
  git add --all
  git commit --amend
}

# Custom git functions
export def "cr" [
  --ai-assisted (-a) # Use claude code to generate the description
  origin?: string # Target branch for the pull request
] {
  git push | print

  match (git ls-remote --get-url origin | str replace -r "^(ssh://git@)|(http(s)?://)" "" | split row / | first) {
    "gitlab.com" => (glab cr --ai-assisted=$ai_assisted $origin),
    $host => (error make {
      msg: $"Unsupported host '($host)'"
    })
  }
}

# Change git working directory
export def --env cd [
  dir: string@"nu-completion repo list"
] {
  alias sys_cd = cd
  if (which ghq | is-empty) {
    error make {
      msg: "Please install https://github.com/x-motemen/ghq to use cdg"
      label: {
        text: "Could not find ghq executable."
      }
    }
  }

  ghq root | str trim | path join $dir | sys_cd $in
}

# Runs a closure against each git directory found.
#
# Example: `git each {|x| ls -D $x}``
export def "git each" [
  closure: closure # Closure to run, argument sent will be the full path of the repo.
  --filter (-f): string # Full text filter to apply to the repo lookup
] {
  ghq list -p ($filter | default "") |
    lines |
    wrap path |
    par-each {insert result (do $closure $in.path) | rename --column {path: repo} | update repo {path basename}}
}

# Nushell version of git status.
export def "st" [] {
    let status_data = git status --short
    | detect columns --no-headers
    | rename status path
    | update status {split chars | append "" | {stage: $in.0, worktree: $in.1}}
    | flatten

    # Check if we're in a merge conflict
    let in_conflict = ($status_data | any {|row| $row.stage == "U" or $row.worktree == "U"})

    # Rename columns based on state
    if $in_conflict {
        $status_data | move path --first | rename stage us | rename worktree them
    } else {
        $status_data | move path --first
    }
}
