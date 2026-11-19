{
  stdenv,
  fetchurl,
  unzip,
  makeDesktopItem,
  buildFHSEnv,
  mono,
  sdl3,
  lib,
  fna3d,
  libGL
}:

let
  pname = "DuckGameRebuilt";
  version = "1.4.8.2";

  DGR = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/TheFlyingFoool/DuckGameRebuilt/releases/download/v1.4.8.5/DuckGameRebuilt.zip";
      sha256 = "sha256-L3xgOSQqyOGli2R+DEgmypHTEoHQslRR0NqQfwnLp98=";
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
    libGL
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/{icons,applications}
    ln -s ${DGR}/DuckGame/DuckGame.ico $out/share/icons/
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  profile = ''export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib"'';
  runScript = "${DGR}/bin/DuckGame.sh -norebuiltupdates";
}
