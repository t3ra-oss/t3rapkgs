def "nu-complete moon targets" [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (
      ^moon query projects --json 
      | from json 
      | get projects 
      | each { |p| 
          $p.tasks 
          | values 
          | each { |t| 
              {
                value: $t.target
              }
            }
        } 
      | flatten
    )
  }
}

def "nu-complete moon log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon theme" [] {
  [ "dark" "light" ]
}

# Take your repo to the moon!
export extern main [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
  ...targets: string@"nu-complete moon targets"        # List of targets to run [-- <args>] Arguments to pass through to the underlying command
]

def "nu-complete moon completions log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon completions theme" [] {
  [ "dark" "light" ]
}

# Generate command completions for your current shell.
export extern "completions" [
  --shell: string           # Shell to generate for
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon completions log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon completions theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon init log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon init theme" [] {
  [ "dark" "light" ]
}

# Initialize a new moon repository, or a new toolchain, by scaffolding config files.
export extern "init" [
  toolchain?: string        # Specific toolchain to initialize
  plugin?: string           # Plugin locator for the toolchain
  --to: string              # Destination to initialize into
  --force                   # Overwrite existing configurations
  --minimal                 # Initialize with minimal configuration and prompts
  --yes                     # Skip prompts and use default values
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon init log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon init theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon debug log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon debug theme" [] {
  [ "dark" "light" ]
}

# Debug internals.
export extern "debug" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon debug log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon debug theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon debug config log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon debug config theme" [] {
  [ "dark" "light" ]
}

# Debug loaded configuration.
export extern "debug config" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon debug config log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon debug config theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon debug vcs log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon debug vcs theme" [] {
  [ "dark" "light" ]
}

# Debug the VCS.
export extern "debug vcs" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon debug vcs log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon debug vcs theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon bin log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon bin theme" [] {
  [ "dark" "light" ]
}

# Return an absolute path to a tool's binary within the toolchain.
export extern "bin" [
  tool: string              # The tool to query
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon bin log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon bin theme" # Terminal theme to print with
  --help(-h)                # Print help (see more with '--help')
  --version(-V)             # Print version
]

def "nu-complete moon node log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon node theme" [] {
  [ "dark" "light" ]
}

# Special Node.js commands.
export extern "node" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon node log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon node theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon node run-script log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon node run-script theme" [] {
  [ "dark" "light" ]
}

# Run a `package.json` script within a project.
export extern "node run-script" [
  name: string              # Name of the script
  --project: string         # ID of project to run in
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon node run-script log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon node run-script theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon setup log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon setup theme" [] {
  [ "dark" "light" ]
}

# Setup the environment by installing all tools.
export extern "setup" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon setup log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon setup theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon teardown log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon teardown theme" [] {
  [ "dark" "light" ]
}

# Teardown the environment by uninstalling all tools and deleting temp files.
export extern "teardown" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon teardown log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon teardown theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon action-graph log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon action-graph theme" [] {
  [ "dark" "light" ]
}

# Display an interactive dependency graph of all tasks and actions.
export extern "action-graph" [
  ...targets: string        # Targets to *only* graph
  --dependents              # Include dependents of the focused target(s)
  --host: string            # The host address
  --port: string            # The port to bind to
  --dot                     # Print the graph in DOT format
  --json                    # Print the graph in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon action-graph log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon action-graph theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon project log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon project theme" [] {
  [ "dark" "light" ]
}

def "nu-complete moon project id" [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: fuzzy,
    },
    completions: (^moon query projects --json | from json | get projects | select -o id config.project.description | rename value description)
  }
}

# Display information about a single project.
export extern "project" [
  id: string@"nu-complete moon project id" # ID of project to display
  --json                    # Print in JSON format
  --no-tasks                # Do not include tasks in output
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon project log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon project theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon project-graph log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon project-graph theme" [] {
  [ "dark" "light" ]
}

# Display an interactive graph of projects.
export extern "project-graph" [
  id?: string               # ID of project to *only* graph
  --dependents              # Include direct dependents of the focused project
  --host: string            # The host address
  --port: string            # The port to bind to
  --dot                     # Print the graph in DOT format
  --json                    # Print the graph in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon project-graph log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon project-graph theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon task-graph log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon task-graph theme" [] {
  [ "dark" "light" ]
}

# Display an interactive graph of tasks.
export extern "task-graph" [
  target?: string           # Target of task to *only* graph
  --dependents              # Include direct dependents of the focused target
  --host: string            # The host address
  --port: string            # The port to bind to
  --dot                     # Print the graph in DOT format
  --json                    # Print the graph in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon task-graph log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon task-graph theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon sync log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon sync theme" [] {
  [ "dark" "light" ]
}

# Sync the workspace to a healthy state.
export extern "sync" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon sync log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon sync theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon sync codeowners log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon sync codeowners theme" [] {
  [ "dark" "light" ]
}

# Aggregate and sync code owners to a `CODEOWNERS` file.
export extern "sync codeowners" [
  --clean                   # Clean and remove previously generated file
  --force                   # Bypass cache and force create file
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon sync codeowners log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon sync codeowners theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon sync config-schemas log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon sync config-schemas theme" [] {
  [ "dark" "light" ]
}

# Generate and sync configuration JSON schemas for use within editors.
export extern "sync config-schemas" [
  --force                   # Bypass cache and force create schemas
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon sync config-schemas log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon sync config-schemas theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon sync hooks log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon sync hooks theme" [] {
  [ "dark" "light" ]
}

# Generate and sync hook scripts for the workspace configured VCS.
export extern "sync hooks" [
  --clean                   # Clean and remove previously generated hooks
  --force                   # Bypass cache and force create hooks
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon sync hooks log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon sync hooks theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon sync projects log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon sync projects theme" [] {
  [ "dark" "light" ]
}

# Sync all projects and configs in the workspace.
export extern "sync projects" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon sync projects log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon sync projects theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon task log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon task theme" [] {
  [ "dark" "light" ]
}

# Display information about a single task.
export extern "task" [
  target: string            # Target of task to display
  --json                    # Print in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon task log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon task theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon generate log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon generate theme" [] {
  [ "dark" "light" ]
}

# Generate and scaffold files from a pre-defined template.
export extern "generate" [
  name: string              # Name of template to generate
  dest?: string             # Destination path, relative from workspace root or working directory
  --defaults                # Use the default value of all variables instead of prompting
  --dryRun                  # Run entire generator process without writing files
  --force                   # Force overwrite any existing files at the destination
  --template                # Create a new template
  ...vars: string           # Arguments to define as variable values
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon generate log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon generate theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon templates log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon templates theme" [] {
  [ "dark" "light" ]
}

# List all templates that are available for code generation.
export extern "templates" [
  --filter: string          # Filter the templates based on this pattern
  --json                    # Print in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon templates log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon templates theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon check log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon check theme" [] {
  [ "dark" "light" ]
}

# Run all build and test related tasks for the current project.
export extern "check" [
  ...ids: string            # List of project IDs to explicitly check
  --all                     # Run check for all projects in the workspace
  --summary(-s)             # Include a summary of all actions that were processed in the pipeline
  --updateCache(-u)         # Bypass cache and force update any existing items
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon check log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon check theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon ci log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon ci theme" [] {
  [ "dark" "light" ]
}

# Run all affected projects and tasks in a CI environment.
export extern "ci" [
  ...targets: string        # List of targets to run
  --base: string            # Base branch, commit, or revision to compare against
  --head: string            # Current branch, commit, or revision to compare with
  --job: string             # Index of the current job
  --jobTotal: string        # Total amount of jobs to run
  --stdin                   # Accept touched files from stdin for affected checks
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon ci log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon ci theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon run profile" [] {
  [ "cpu" "heap" ]
}

def "nu-complete moon run log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon run theme" [] {
  [ "dark" "light" ]
}

# Run one or many project tasks and their dependent tasks.
export extern "run" [
  --dependents              # Run dependents of the primary targets
  --force(-f)               # Force run and ignore touched files and affected status
  --interactive(-i)         # Run the target interactively
  --query: string           # Focus target(s) based on the result of a query
  --summary(-s)             # Include a summary of all actions that were processed in the pipeline
  --updateCache(-u)         # Bypass cache and force update any existing items
  --no-actions              # Run the task without including sync and setup related actions in the graph
  --no-bail(-n)             # When a task fails, continue executing other tasks instead of aborting immediately
  --profile: string@"nu-complete moon run profile" # Record and generate a profile for ran tasks
  --affected                # Only run target if affected by touched files or the environment
  --remote                  # Determine affected against remote by comparing against a base revision
  --status: string          # Filter affected files based on a touched status
  --stdin                   # Accept touched files from stdin for affected checks
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon run log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon run theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
  ...targets: string@"nu-complete moon targets"        # List of targets to run [-- <args>] Arguments to pass through to the underlying command
]

def "nu-complete moon ext log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon ext theme" [] {
  [ "dark" "light" ]
}

# Execute an extension plugin.
export extern "ext" [
  id: string                # ID of the extension to execute
  ...passthrough: string    # Arguments to pass through to the extension
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon ext log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon ext theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon toolchain log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon toolchain theme" [] {
  [ "dark" "light" ]
}

# Manage toolchain plugins.
export extern "toolchain" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon toolchain log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon toolchain theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon toolchain add log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon toolchain add theme" [] {
  [ "dark" "light" ]
}

# Add and configure a toolchain plugin in .moon/toolchain.yml.
export extern "toolchain add" [
  id: string                # ID of the toolchain to add
  plugin?: string           # Plugin locator string to find and load the toolchain
  --minimal                 # Initialize with minimal configuration and prompts
  --yes                     # Skip prompts and use default values
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon toolchain add log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon toolchain add theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon toolchain info log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon toolchain info theme" [] {
  [ "dark" "light" ]
}

# Show detailed information about a toolchain plugin.
export extern "toolchain info" [
  id: string                # ID of the toolchain to inspect
  plugin?: string           # Plugin locator string to find and load the toolchain
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon toolchain info log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon toolchain info theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon clean log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon clean theme" [] {
  [ "dark" "light" ]
}

# Clean the workspace and delete any stale or invalid artifacts.
export extern "clean" [
  --lifetime: string        # Lifetime of cached artifacts
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon clean log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon clean theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon docker log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon docker theme" [] {
  [ "dark" "light" ]
}

# Operations for integrating with Docker and Dockerfile(s).
export extern "docker" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon docker log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon docker theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon docker file log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon docker file theme" [] {
  [ "dark" "light" ]
}

# Generate a default Dockerfile for a project.
export extern "docker file" [
  id: string@"nu-complete moon project id"                # ID of project to create a Dockerfile for
  dest?: string             # Destination path, relative from the project root
  --defaults                # Use default options instead of prompting
  --buildTask: string       # ID of a task to build the project
  --image: string           # Base Docker image to use
  --no-prune                # Do not prune the workspace in the build stage
  --no-toolchain            # Do not use the toolchain and instead use system binaries
  --startTask: string       # ID of a task to run the project
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon docker file log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon docker file theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon docker prune log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon docker prune theme" [] {
  [ "dark" "light" ]
}

# Remove extraneous files and folders within a Dockerfile.
export extern "docker prune" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon docker prune log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon docker prune theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon docker scaffold log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon docker scaffold theme" [] {
  [ "dark" "light" ]
}

# Scaffold a repository skeleton for use within Dockerfile(s).
export extern "docker scaffold" [
  ...ids: string            # List of project IDs to copy sources for
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon docker scaffold log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon docker scaffold theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon docker setup log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon docker setup theme" [] {
  [ "dark" "light" ]
}

# Setup a Dockerfile by installing dependencies for necessary projects.
export extern "docker setup" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon docker setup log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon docker setup theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon mcp log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon mcp theme" [] {
  [ "dark" "light" ]
}

# Start an MCP (model context protocol) server that can respond to AI agent requests.
export extern "mcp" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon mcp log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon mcp theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon migrate log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon migrate theme" [] {
  [ "dark" "light" ]
}

# Operations for migrating existing projects to moon.
export extern "migrate" [
  --skipTouchedFilesCheck   # Disable the check for touched/dirty files
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon migrate log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon migrate theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon migrate from-package-json log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon migrate from-package-json theme" [] {
  [ "dark" "light" ]
}

# Migrate `package.json` scripts and dependencies to `moon.*`.
export extern "migrate from-package-json" [
  id: string@"nu-complete moon project id"                # ID of project to migrate
  --skipTouchedFilesCheck   # Skip checking for touched files to determine if the repo is dirty
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon migrate from-package-json log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon migrate from-package-json theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon migrate from-turborepo log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon migrate from-turborepo theme" [] {
  [ "dark" "light" ]
}

# Migrate `turbo.json` to moon configuration files.
export extern "migrate from-turborepo" [
  --skipTouchedFilesCheck   # Disable the check for touched/dirty files
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon migrate from-turborepo log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon migrate from-turborepo theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon query log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query theme" [] {
  [ "dark" "light" ]
}

# Query information about moon, the environment, and pipeline.
export extern "moon query" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query theme" # Terminal theme to print with
  --help(-h)                # Print help (see more with '--help')
  --version(-V)             # Print version
]

def "nu-complete moon query hash log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query hash theme" [] {
  [ "dark" "light" ]
}

# Inspect the contents of a generated hash.
export extern "query hash" [
  hash: string              # Hash to inspect
  --json                    # Print the manifest in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query hash log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query hash theme" # Terminal theme to print with
  --help(-h)                # Print help (see more with '--help')
  --version(-V)             # Print version
]

def "nu-complete moon query hash-diff log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query hash-diff theme" [] {
  [ "dark" "light" ]
}

# Query the difference between two hashes.
export extern "query hash-diff" [
  left: string              # Base hash to compare against
  right: string             # Other hash to compare with
  --json                    # Print the diff in JSON format
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query hash-diff log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query hash-diff theme" # Terminal theme to print with
  --help(-h)                # Print help (see more with '--help')
  --version(-V)             # Print version
]

def "nu-complete moon query projects downstream" [] {
  [ "none" "direct" "deep" ]
}

def "nu-complete moon query projects upstream" [] {
  [ "none" "direct" "deep" ]
}

def "nu-complete moon query projects log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query projects theme" [] {
  [ "dark" "light" ]
}

# Query for projects within the project graph.
export extern "query projects" [
  query?: string            # Filter projects using a query (takes precedence over options)
  --alias: string           # Filter projects that match this alias
  --affected                # Filter projects that are affected based on touched files
  --dependents              # Include direct dependents of queried projects
  --downstream: string@"nu-complete moon query projects downstream" # Include downstream dependents of queried projects
  --id: string              # Filter projects that match this ID
  --json                    # Print the projects in JSON format
  --language: string        # Filter projects of this programming language
  --stack: string           # Filter projects that match this source path
  --source: string          # Filter projects of this tech stack
  --tags: string            # Filter projects that have the following tags
  --tasks: string           # Filter projects that have the following tasks
  --type: string            # Filter projects of this type
  --upstream: string@"nu-complete moon query projects upstream" # Include upstream dependencies of queried projects
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query projects log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query projects theme" # Terminal theme to print with
  --help(-h)                # Print help (see more with '--help')
  --version(-V)             # Print version
]

def "nu-complete moon query tasks downstream" [] {
  [ "none" "direct" "deep" ]
}

def "nu-complete moon query tasks upstream" [] {
  [ "none" "direct" "deep" ]
}

def "nu-complete moon query tasks log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query tasks theme" [] {
  [ "dark" "light" ]
}

# List all available tasks, grouped by project.
export extern "query tasks" [
  query?: string            # Filter tasks using a query (takes precedence over options)
  --affected                # Filter tasks that are affected based on touched files
  --downstream: string@"nu-complete moon query tasks downstream" # Include downstream dependents of queried tasks
  --upstream: string@"nu-complete moon query tasks upstream" # Include upstream dependencies of queried tasks
  --id: string              # Filter tasks that match this ID
  --json                    # Print the tasks in JSON format
  --command: string         # Filter tasks with the provided command
  --platform: string        # Filter tasks that belong to a platform
  --project: string         # Filter tasks that belong to a project
  --script: string          # Filter tasks with the provided script
  --toolchain: string       # Filter tasks that belong to a toolchain
  --type: string            # Filter projects of this type
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query tasks log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query tasks theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon query touched-files default_branch" [] {
  [ "true" "false" ]
}

def "nu-complete moon query touched-files log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon query touched-files theme" [] {
  [ "dark" "light" ]
}

# Query for touched files between revisions.
export extern "query touched-files" [
  --base: string            # Base branch, commit, or revision to compare against
  --defaultBranch: string@"nu-complete moon query touched-files default_branch" # When on the default branch, compare against the previous revision
  --head: string            # Current branch, commit, or revision to compare with
  --json                    # Print the files in JSON format
  --local                   # Gather files from you local state instead of the remote
  --status: string          # Filter files based on a touched status
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon query touched-files log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon query touched-files theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]

def "nu-complete moon upgrade log" [] {
  [ "off" "error" "warn" "info" "debug" "trace" "verbose" ]
}

def "nu-complete moon upgrade theme" [] {
  [ "dark" "light" ]
}

# Upgrade to the latest version of moon.
export extern "upgrade" [
  --cache: string           # Mode for cache operations
  --color                   # Force colored output
  --concurrency(-c): string # Maximum number of threads to utilize
  --dump                    # Dump a trace profile to the working directory
  --log: string@"nu-complete moon upgrade log" # Lowest log level to output
  --logFile: path           # Path to a file to write logs to
  --quiet(-q)               # Hide all non-important terminal output
  --theme: string@"nu-complete moon upgrade theme" # Terminal theme to print with
  --help(-h)                # Print help
  --version(-V)             # Print version
]
