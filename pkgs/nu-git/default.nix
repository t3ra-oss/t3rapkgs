{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "git";
  version = "0.1.2";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.2";
        hash = "sha256-+OJ0R0MuMBhQGG/vIcl2H9xLc9LvG9ViyVFFA2JceG8=";
      }
    + "/pkgs/git";

  meta = {
    description = "Git workflow helpers - conventional commits, gh/glab merge requests, branch cleanup, structured status/log";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
