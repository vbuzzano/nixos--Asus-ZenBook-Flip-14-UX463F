with (import <nixpkgs> {});

stdenv.mkDerivation rec {
  pname = "grub-theme-dedsec-spyware";
  version = "3.0";

  tmpDir = "/tmp/${pname}.${version}";

  src = fetchurl {
    url = "https://dl2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MzcxOTk4MzMiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6ImZjYTZhMDA2NjdlM2Q0YmFiYmZlMTZkNmIyZGI4MTA1YWI3Njc3MDMzNGYzNDA5NjllNDIxOGQ2NmM3MTE4ZjBhN2RjZDA3ZmI2MjNjYjgzZTBmY2E5ZTM2Nzk4YjU1ZjlhZjA3ZDkwNGZiNWQxZDc1ZmE2NGZlYzQyOWFjOTM2IiwidCI6MTY0MDU2MDkzNSwic3RmcCI6IjdhZTM1MGEyZWYwYWQxMjMzNmRjMjBmMzhlZDExMjY1Iiwic3RpcCI6IjE3OC4xOTcuMjI3LjQ2In0.fojWQXVUxXcznfROEiX2O2MuDKJpm5XOo8YTs-Llq6w/dedsec-spyware.zip";
    sha256 = "cb6717292817eaa6200523c8821cb09a668d5c33b32c82d5f974644b659e2630";
  };

  nativeBuildInputs = [ unzip ];

  # buildInputs = [ gdk-pixbuf librsvg gtk_engines ];

  unpackPhase = ''
    unzip $src -d $tmpDir
    mv $tmpDir/dedsec $out
    rm -r $tmpDir
  '';


  installPhase = ''
    echo "Done"
  '';

  meta = with lib; {
    description = "DedSec GRUB Theme was created, inspired by the fictional hacker group DedSec from Watch Dogs video game developed by Ubisoft.";
    homepage = "https://store.kde.org/p/1569525";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
