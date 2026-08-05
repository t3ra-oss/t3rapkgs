{ stdenvNoCC, nushell }:

# Turn a nupm-format package source into a Nix derivation, laid out the way
# nupm's own installer would lay it out under $NUPM_HOME: module packages
# under $out/modules/<name>, script packages under $out/scripts. This is the
# packaging half only - nupm.nuon's `type: custom` (which runs its own
# build.nu) has no caller yet and is intentionally unsupported.
#
# Arguments:
#   pname: Package name, checked against nupm.nuon's `name`
#   version: Package version
#   src: Directory containing nupm.nuon and the package content
#   ...: Passed through to stdenvNoCC.mkDerivation (meta, etc.)
{ pname, version, src, ... }@args:

let
  extraArgs = builtins.removeAttrs args [ "pname" "version" "src" ];
in
stdenvNoCC.mkDerivation ({
  inherit pname version src;

  nativeBuildInputs = [ nushell ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    nu ${./install.nu} "$PWD" "$out" "${pname}"
    runHook postInstall
  '';
} // extraArgs)
