{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "git";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.0";
        hash = "sha256-Hhj7FSFdbd40r70SmjZNJAn4PWPFbX1BmE/BynQCKc4=";
      }
    + "/pkgs/git";

  meta = {
    description = "Git workflow helpers - conventional commits, gh/glab merge requests, branch cleanup, structured status/log";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
