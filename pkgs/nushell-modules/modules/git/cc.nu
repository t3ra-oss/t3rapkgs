
# Conventional commit configuration
export-env {
  $env.conventional_commit = {
    re: '^(?P<type>\w+)(?:\((?P<scope>[^)]+)\))?!?: (?P<message>.+)$',
    types: {
      feat:  {priority: 0, triggers: "minor"}
      infra: {priority: 3, triggers: "minor"}
      perf:  {priority: 5, triggers: "minor"}

      fix:   {priority: 10, triggers: "patch"}
      chore: {priority: 15, triggers: "patch"}

      test:  {priority: 100, triggers: null}
      build: {priority: 110, triggers: null}
      ci:    {priority: 120, triggers: null}
      docs:  {priority: 130, triggers: null}
      style: {priority: 140, triggers: null}
      wip:   {priority: 150, triggers: null}
    }
  }
}

# conventional type completion
def comp_types [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: ($env.conventional_commit.types | columns)
  }
}

# git revision completion
def comp_rev [
  context: list
] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (carapace git nushell log ...$context | from json)
  }
}

# checkout new git branch
export def "checkout" [
  --type (-t): string@comp_types # type of the branch
  ...name: string # name of the branch
] {
  mut branch = ''

  if ($type | is-not-empty) {
    $branch += $type + "/"
  }

  $branch += $name | str join '-'
  $branch = $branch |
    str trim |
    str replace --all --regex --multiline '\s+' '-' |
    str trim --char '/' |
    str downcase

  ^git checkout -b $branch
}


# git structured logs
export def "logs" [
  ...rev: string@comp_rev # revision range
] {
  ^git log --pretty=%h»¦«%aN»¦«%s»¦«%aD ...$rev |
    lines | split column "»¦«" hash author message date | upsert date {|d| $d.date | into datetime} |
    each {|row|
      let msg = ($row | get message)
      # Try extracting context from the message
      let commit = match ($msg | parse -r $env.conventional_commit.re ) {
        [] => [{type: null, scope: null, message: $msg}]
        $c => $c
      } | first | insert break ($msg =~ '^(?:\w+(?:\(\w+\))?)!:|^.*BREAKING CHANGE')

      $row | merge $commit | move type scope --before message
    }
}


# git commit with conventional format
export def "commit" [
  type: string@comp_types # type of the commit
  --scope (-s): string # scope of the commit
  --break (-b) # mark the commit as breaking change
  ...msg: string # commit message
] {
  let allowed_types = ($env.conventional_commit.types | columns)
  if ($type not-in $allowed_types) {
    error make {
      msg: $"Type must be one of ($allowed_types | str join ', ')"
      label: {
        text: $"($type) is not allowed."
        span: (metadata $type).span
      }
    }
  }

  let msg_scope = match $scope {
    '' => '',
    null => '',
    $s => $"\(($s)\)"
  }

  let msg_sep = match $break {
    true => "!:"
    _ => ":"
  }

  let commit_msg = $"($type)($msg_scope)($msg_sep) ($msg | str join ' ')"

  ^git commit -s -m $"($commit_msg)"
}

# Get git commit logs for the change introduced in the current branch.
export def "changelog" [
  origin?: string # Origin to compare HEAD to.
] {
  let origin = $origin | default (^git symbolic-ref refs/remotes/origin/HEAD --short)
  logs $"($origin)..HEAD"
}

# Get a human friendly description of the change introduced.
export def "changedesc" [
  --ai-assisted (-a) # Use claude code to generate the description
  origin?: string # Origin to compare HEAD to.
] {
  let origin = $origin | default (^git symbolic-ref refs/remotes/origin/HEAD --short)
  let cl = changelog $origin

  # Initialise body and title
  mut title = ""
  mut body = ""

  if $ai_assisted {
    let ai_resp = (claude -p "Summarize the changes made on this branch. It will be merged into $origin. Be concise and useful for reviewers. You can use markdown format. Also generate a title with conventional commit format. If there's any issue linked to this branch, add its ID at the end of the title (<conventional-commit-title> [ISSUE-ID]). Output must be a valid raw JSON {"title":"<title>", "body":"<body>"}, don't use triple quote or anything. Pure raw JSON." |
      from json )

    $title = $ai_resp.title
    $body = $ai_resp.body
  } else {
    let mr_type = $cl | get type |
      sort-by -c {|x,y|
        let p1 = ($env.conventional_commit.types | get -o $x | get -o priority)
        let p2 = ($env.conventional_commit.types | get -o $y | get -o priority)
        $p1 < $p2
      } | first | default "unkown"

    $title = $mr_type

    # Handle scopes
    let scopes = $cl | get scope | compact -e
    if ($scopes | is-not-empty) {
      $title += "(" + ($scopes | str join ',') + ")"
    }

    # Handle breaking changes
    if ($cl | where break | is-not-empty) {
      $title += "!"
      $body += "> **Warning** :warning:\n> This merge request introduce a **breaking change**."
    }

    # Handle branch tokens
    let branch_token = ^git rev-parse --abbrev-ref HEAD | split row /
    mut title_desc = $branch_token | last | str replace --all "-" " "
    if ($branch_token | length) >= 3 {
      # Include issue reference
      $title_desc += " [" + "($branch_token.1)" + "]"
    }
    $title += ": " + $title_desc

    let stats = ^git diff --shortstat $"($origin)..HEAD"
    let body = $"This change request introduces($stats)\n\n## Changelog\n($cl | to md)"
  }

  {title: $title, body: $body, draft: ($cl | where type == "wip" | is-not-empty )}
}

