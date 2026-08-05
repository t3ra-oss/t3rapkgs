{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "moon";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.1";
        hash = "sha256-k+j6U70GoPXN++G80X12C7lj/Q24K1u/Y4NTVJguZDo=";
      }
    + "/pkgs/moon";

  meta = {
    description = "moon monorepo tool integration - project cd/run/check helpers and full CLI completions";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
