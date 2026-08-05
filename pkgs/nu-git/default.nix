{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "git";
  version = "0.1.1";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.1";
        hash = "sha256-k+j6U70GoPXN++G80X12C7lj/Q24K1u/Y4NTVJguZDo=";
      }
    + "/pkgs/git";

  meta = {
    description = "Git workflow helpers - conventional commits, gh/glab merge requests, branch cleanup, structured status/log";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
