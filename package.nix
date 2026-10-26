{
  stdenv,
  fetchurl,
  unzip,
  makeDesktopItem,
  buildFHSEnv,
  mono,
  sdl3,
  lib,
  fna3d
}:

let
  pname = "DuckGameRebuilt";
  version = "1.4.8";

  DGR = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/TheFlyingFoool/DuckGameRebuilt/releases/download/v1.4.8/DuckGameRebuilt.zip";
      sha256 = "4pwJxCAxKxyy0SuI1+C2A1DWnQ0ZHkxLzxOU0husmqQ=";
    };

    dontBuild = true;
    dontConfigure = true;
    dontStrip = true;

    nativeBuildInputs = [ unzip ];

    sourceRoot = ".";

    unpackPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
    '';

    installPhase = ''
      chmod +x $out/bin/DuckGame.sh
    '';
  };
  desktopItem = makeDesktopItem {
    name = "Duck Game Rebuilt";
    exec = "DuckGameRebuilt";
    genericName = "Duck Game decompiled & rebuilt with some added features";
    desktopName = "Duck Game Rebuilt";
    icon = "DuckGame"; # I know it's broken I'll deal with it later
  };
in

buildFHSEnv {
  name = pname;
  targetPkgs = pkgs: [
    mono
    sdl3
    fna3d
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/{icons,applications}
    ln -s ${DGR}/DuckGame/DuckGame.ico $out/share/icons/
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  runScript = "${DGR}/bin/DuckGame.sh -norebuiltupdates";
}
