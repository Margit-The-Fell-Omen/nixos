{
    stdenvNoCC,
    lib,
    fetchFromGitLab,
    ...
}:
stdenvNoCC.mkDerivation rec {
    pname = "arasaka-plymouth-theme";
    version = "6b704007428332efe1484d752fefe073068ffd9e";

    src = fetchFromGitLab {
        owner = "pSchwietzer";
        repo = "arasaka-plymouth";
        rev = "${version}";
        hash = "sha256-vdTuCNRzqWLAFu7Fb3YjByRwQuVS7yAjC5+7fQFxWM4=";
    };

    installPhase = ''
        runHook preInstall

        realOut=$out/share/plymouth/themes/arasaka/

        mkdir -p $realOut
        cp -r * $realOut

        substituteInPlace $realOut/arasaka.plymouth \
            --replace @ROOT@ $realOut

        runHook postInstall
    '';

    meta = {
        description = "A plymouth theme inspired by the Arasaka Corporation from Cyberpunk 2077.";
        homepage = "https://gitlab.com/pSchwietzer/arasaka-plymouth";
        license = lib.licenses.gpl3Only;
    };
}
