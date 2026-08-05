{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "kubectl";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "d603704fc6e781a54ed1ee09d0ae1f77c9b933b5";
        hash = "sha256-YavLytEJEfJE7hCf0Lx5Jz7kgK1Xub40wvuBl6j3XJ0=";
      }
    + "/pkgs/kubectl";

  meta = {
    description = "Short aliases for common kubectl operations";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
