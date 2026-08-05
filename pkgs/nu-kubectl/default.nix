{ buildNupmPackage, fetchFromGitHub, lib }:

buildNupmPackage {
  pname = "kubectl";
  version = "0.1.0";

  src =
    fetchFromGitHub
      {
        owner = "t3ra-oss";
        repo = "nupkgs";
        rev = "v0.1.0";
        hash = "sha256-Hhj7FSFdbd40r70SmjZNJAn4PWPFbX1BmE/BynQCKc4=";
      }
    + "/pkgs/kubectl";

  meta = {
    description = "Short aliases for common kubectl operations";
    homepage = "https://github.com/t3ra-oss/nupkgs";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
