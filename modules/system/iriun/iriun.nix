{
    stdenv,
    fetchurl,
    dpkg,
    autoPatchelfHook,
    makeWrapper,
    lib,
    qt5,
    alsa-lib,
    avahi,
    libusbmuxd,
    libimobiledevice,
}:
stdenv.mkDerivation rec {
    pname = "iriunwebcam";
    version = "2.9.1";

    src = fetchurl {
        url = "https://iriun.gitlab.io/iriunwebcam-${version}.deb";
        sha256 = "sha256-slpTyetT96waR7XvcXSZDdl/Ziacc4hgM5XCxX8WC4Q=";
    };

    nativeBuildInputs = [
        dpkg
        autoPatchelfHook
        qt5.wrapQtAppsHook
        makeWrapper
    ];

    buildInputs = [
        alsa-lib
        avahi
        libusbmuxd
        qt5.qtbase
        stdenv.cc.cc.lib
    ];

    unpackPhase = ''
        dpkg-deb -x $src .
    '';

    installPhase = ''
        runHook preInstall

        install -Dm755 usr/local/bin/iriunwebcam $out/bin/iriunwebcam
        install -Dm644 usr/share/applications/iriunwebcam.desktop $out/share/applications/iriunwebcam.desktop
        install -Dm644 usr/share/pixmaps/iriunwebcam.png $out/share/pixmaps/iriunwebcam.png

        substituteInPlace $out/share/applications/iriunwebcam.desktop \
          --replace-fail "/usr/local/bin/iriunwebcam" "$out/bin/iriunwebcam" \

        wrapProgram $out/bin/iriunwebcam --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
            libusbmuxd
            libimobiledevice
        ]}";

        runHook postInstall
    '';

    meta = with lib; {
        description = "Use your phone as a webcam via Iriun";
        homepage = "https://iriun.com";
        license = licenses.unfree;
        platforms = ["x86_64-linux"];
        mainProgram = "iriunwebcam";
    };
}
