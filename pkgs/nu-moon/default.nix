{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "moon";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.2";
        hash = "sha256-+OJ0R0MuMBhQGG/vIcl2H9xLc9LvG9ViyVFFA2JceG8=";
      }
    + "/pkgs/moon";

  meta = {
    description = "moon monorepo tool integration - project cd/run/check helpers and full CLI completions";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
