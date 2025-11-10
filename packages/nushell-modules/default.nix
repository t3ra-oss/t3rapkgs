{ stdenv, lib, enabledModules ? null }:

let
  # Default to all available modules if none specified
  allModules = [ "git" "halp" "moon" ];
  selectedModules = if enabledModules != null then enabledModules else allModules;
in

stdenv.mkDerivation rec {
  pname = "t3ra-nushell-modules";
  version = "0.1.0";

  src = ./modules;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out
    
    # Copy only selected modules
    ${lib.concatMapStringsSep "\n    " (module: ''
      if [ -d "${module}" ]; then
        cp -r ${module} $out/
      else
        echo "Warning: Module '${module}' not found, skipping"
      fi
    '') selectedModules}
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "T3RA's nushell modules and overlays";
    homepage = "https://github.com/t3ra-oss/t3rapkgs";
    license = licenses.mit;
    maintainers = [ "bastien@t3ra.cloud" ];
    platforms = platforms.all;
  };
}
