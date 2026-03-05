{
    stdenvNoCC,
    lib,
    fetchFromGitHub,
    ...
}:
stdenvNoCC.mkDerivation rec {
    pname = "ecorp-glitch-plymouth-theme";
    version = "0bdfe0da437d6c001a31b280bc212b5c0dd3ef67";

    src = fetchFromGitHub {
        owner = "hrshbh";
        repo = "plymouth-themes";
        rev = "${version}";
        hash = "sha256-UT+OOf8hmrpl9/ZI+g42ifPb4INVzOyY9kC+FL2twF8=";
    };

    installPhase = ''
        runHook preInstallw

        realOut=$out/share/plymouth/themes

        mkdir -p $realOut
        cp -r ecorp-glitch $realOut

        substituteInPlace $realOut/ecorp-glitch/ecorp-glitch.plymouth \
            --replace /usr/share/plymouth/themes $realOut

        runHook postInstall
    '';

    meta = {
        description = "Boot Animations (Plymouth themes) for the GNU/Linux Operating System.";
        homepage = "https://github.com/hrshbh/plymouth-themes";
        license = lib.licenses.gpl3Only;
    };
}
