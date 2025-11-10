use cc.nu

# Lookup one or multiple glab repositories and clone them locally.
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

  let san_search = ($search | str join '-' | str trim | str replace ' ' '-')
  let endpoint = $"/search?scope=projects&search=($san_search)"

  glab api $endpoint --paginate |
    from json |
    sk -m --format {get name_with_namespace} --preview {to yaml | nu-highlight} |
    par-each {|repo|
      ghq get $repo.ssh_url_to_repo | print

      {remote: $repo.ssh_url_to_repo, local: (ghq list -p $repo.ssh_url_to_repo)}
    }
}
  
# Create a GitLab merge request.
#
# This will use both the commit history and branch name to fill up the merge request
# title and description.
# It will mark the MR as draft if the commit history contains a wip commit.
export def "cr" [
  --ai-assisted (-a) # Use claude code to generate the description
  origin?: string # ref to merge into.
] {
  let origin = $origin | default (git symbolic-ref refs/remotes/origin/HEAD --short)
  let desc = cc changedesc --ai-assisted=$ai_assisted $origin
  
  let flags = [
    "--no-editor",
    "--remove-source-branch",
    "--yes",
    (if $desc.draft {"--draft"}),
  ] | compact
  glab mr create --title $desc.title --description $desc.body --target-branch ($origin | str replace -r "^origin/" "") ...$flags
}
