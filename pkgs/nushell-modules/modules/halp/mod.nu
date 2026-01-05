use ../moon


# Contextual help function
export def main [] {
  mut pid = ""
  try {
    $pid = (moon curr)
  }

  match $pid {
    "" => (halp_root),
    _ => (halp_project $pid)
  }
}

def halp_common [] {
  print "📂 Navigation:"
  print "    hop <project-id>        Jump to project root folder (tab completion enabled)"
  print "    hop                     Stay in repo root\n"

  print "🔧 Quick Commands:"
  print "    git st                  Enhanced git status with conflict detection"
  print "    git cr                  Create PR/MR (auto-detects gitlab/github)"
  print "    git tidy                Clean up merged branches"
  print "    exit                    Exit the nix development shell\n"

  print "📚 Full docs: https://github.com/t3ra-oss/t3rapkgs\n"
}

def halp_root [] {
  print "🚀 Tranquility Infrastructure Repository\n"

  halp_common

  print "🌙 Moon Tasks:"
  print "    moon <project>:<task-id>    Run task in specific project"
  print "    moon query projects            List all available projects"
  print "    moon --help                    Show moon help\n"

  print "💡 Examples:"
  print "    hop gcp.project.hub            # Navigate to hub project"
  print "    moon gcp.project.hub:plan      # Run terraform plan in hub"
  print "    moon gcp.project.hub:init      # Initialize terraform in hub"
  print "    moon query projects | grep gcp # Find GCP projects\n"

  print "🔗 Use 'halp' inside any project for project-specific commands!"
}

def halp_project [
  pid: string
] {
  let project_info = (^moon project $pid --json | from json)
  let project_name = $project_info.config.project.name
  let project_desc = $project_info.config.project.description

  print $"🎯 Project: ($project_name) \(($pid)\)\n"
  print $"📝 ($project_desc)\n"

  halp_common

  print "🏃 Quick Tasks:"
  print "    run <task-id> [...task-ids]    Run task(s) in current project"
  print "    info                           Show detailed project info and available tasks\n"
  print ""

  print "🔄 Use 'halp' from repo root for global commands!"
}
