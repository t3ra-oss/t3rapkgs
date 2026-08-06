{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "kubectl";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.2";
        hash = "sha256-+OJ0R0MuMBhQGG/vIcl2H9xLc9LvG9ViyVFFA2JceG8=";
      }
    + "/pkgs/kubectl";

  meta = {
    description = "Short aliases for common kubectl operations";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
