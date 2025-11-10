use cc.nu

# Lookup one or multiple github repositories and clone them locally.
export def "grab" [
  ...search: string # Pre-filter full-text search
] {
  if ($search | is-empty) {
    error make {
      msg: "You must provide search term(s)"
      label: {
        text: "Search is empty"
        span: (metadata $search).span
      }
    }
  }

  gh search repos --json fullName,url,stargazersCount,visibility,license --limit 100 ...$search |
    from json |
    sk -m --format {get fullName} --preview {to yaml | nu-highlight} |
    par-each {|repo|
      let repo_url = ($repo.url | str replace -r "^https://" "ssh://git@") + ".git"
      ghq get $repo_url | print

      {remote: $repo_url, local: (ghq list -p $repo_url)} 
    }
}

# Create a GitHub merge request
#
# This will use both the commit history and branch name to fill up the pull request
# title and description.
# It will mark the PR as draft if the commit history contains a wip commit.
export def "cr" [
  --ai-assisted (-a) # Use claude code to generate the description
  origin?: string # Target branch for the pull request
] {
  let origin = $origin | default (git symbolic-ref refs/remotes/origin/HEAD --short)
  let desc = git cc changedesc --ai-assisted=$ai_assisted $origin

  let flags = [
    (if $desc.draft {{"--draft"}}),
  ] | compact
  gh pr create --title $desc.title --body $desc.body --base ($origin | str replace -r "^origin/" "") ...$flags
}
