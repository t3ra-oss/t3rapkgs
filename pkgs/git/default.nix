{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "git";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "d603704fc6e781a54ed1ee09d0ae1f77c9b933b5";
        hash = "sha256-YavLytEJEfJE7hCf0Lx5Jz7kgK1Xub40wvuBl6j3XJ0=";
      }
    + "/pkgs/git";

  meta = {
    description = "Git workflow helpers - conventional commits, gh/glab merge requests, branch cleanup, structured status/log";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
