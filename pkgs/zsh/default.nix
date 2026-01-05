{ stdenv, lib, pkgs, enabledExtensions ? null }:

let
  # Default extensions if none specified
  defaultExtensions = [ "autosuggestions" "syntax-highlighting" ];
  selectedExtensions = if enabledExtensions != null then enabledExtensions else defaultExtensions;

  # Helper to get zsh extension package from pkgs
  getExtensionPackage = ext:
    let
      pkgName = "zsh-${ext}";
    in
    if pkgs ? ${pkgName}
    then pkgs.${pkgName}
    else throw "Unknown zsh extension: ${ext}. Package ${pkgName} not found in nixpkgs.";
in

stdenv.mkDerivation {
  pname = "t3ra-zsh";
  version = "0.1.0";

  src = ./.;

  dontBuild = true;
  dontConfigure = true;

  buildInputs = [ pkgs.oh-my-zsh ] ++ (map getExtensionPackage selectedExtensions);

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Copy .zshrc
    cp ${./default.zshrc} $out/.zshrc

    # Create metadata file with extension paths
    cat > $out/extensions.sh << 'EOF'
# Auto-generated extension paths
export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
${lib.concatMapStringsSep "\n" (ext:
  let
    pkgName = "zsh-${ext}";
    pkg = getExtensionPackage ext;
    envVar = lib.toUpper (lib.replaceStrings ["-"] ["_"] pkgName);
  in
  ''export ${envVar}="${pkg}"''
) selectedExtensions}
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "T3RA's zsh configuration with oh-my-zsh and extensions";
    homepage = "https://github.com/t3ra-oss/t3rapkgs";
    license = licenses.mit;
    maintainers = [ "bastien@t3ra.cloud" ];
    platforms = platforms.all;
  };
}
