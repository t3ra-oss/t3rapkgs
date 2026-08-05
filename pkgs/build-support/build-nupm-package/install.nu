# Lay out a nupm-format package under $out the way nupm's own installer
# would lay it out under $NUPM_HOME (see nupm/install.nu's `install-path`
# in https://github.com/nushell/nupm): module packages go to
# $out/modules/<name>, script packages (and any package's extra `scripts`
# list) go to $out/scripts.
def main [
  src: path # unpacked package source, contains nupm.nuon
  out: path # Nix $out
  expected_name: string # pname, checked against nupm.nuon's `name`
] {
  let manifest = $src | path join nupm.nuon | open

  if $manifest.name != $expected_name {
    error make {
      msg: $"nupm.nuon name '($manifest.name)' does not match pname '($expected_name)'"
    }
  }

  match $manifest.type {
    "module" => {
      let mod_dir = $src | path join $manifest.name
      if ($mod_dir | path type) != "dir" {
        error make {
          msg: $"module package '($manifest.name)' has no '($manifest.name)/' directory"
        }
      }

      let modules_dir = $out | path join modules
      mkdir $modules_dir
      cp --recursive $mod_dir $modules_dir

      for script in ($manifest.scripts? | default []) {
        let scripts_dir = $out | path join scripts
        mkdir $scripts_dir
        cp ($src | path join $script) $scripts_dir
      }
    },
    "script" => {
      let scripts_dir = $out | path join scripts
      mkdir $scripts_dir

      let scripts = [$"($manifest.name).nu"] | append ($manifest.scripts? | default [])
      for script in $scripts {
        cp ($src | path join $script) $scripts_dir
      }
    },
    _ => {
      error make {
        msg: $"unsupported nupm package type '($manifest.type)' - only 'module' and 'script' are supported"
      }
    },
  }
}
