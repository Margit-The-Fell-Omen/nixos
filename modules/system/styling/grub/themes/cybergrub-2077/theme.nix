{
    stdenvNoCC,
    lib,
    fetchFromGitHub,
    logo ? "samurai",
    ...
}: let
    version = "cf633b63db74d1f0e3d2d8591247a5aab63c9961";
    src = fetchFromGitHub {
        owner = "adnksharp";
        repo = "CyberGRUB-2077";
        rev = "${version}";
        hash = "sha256-OGqmHL2qqtWS47GguEklp9S3wU/EwzPEyKJQyCFOKsM=";
    };

    validLogos = map (file: lib.removeSuffix ".png" file) (builtins.attrNames (lib.filterAttrs (name: type: type != "directory" && lib.hasSuffix ".png" name) (builtins.readDir "${src}/img/logos")));
in
    assert lib.assertOneOf "logo" logo validLogos;
        stdenvNoCC.mkDerivation {
            inherit version;
            inherit src;

            pname = "cybergrub-grub-theme";

            installPhase = ''
                dir="$out/share/grub/themes/cybergrub-2077"

                mkdir -p "$dir"
                cp -r CyberGRUB-2077/* "$dir"
                cp "img/logos/${logo}.png" "$dir/logo.png"
            '';

            meta = {
                description = "GRUB Bootloader Theme Inspired by Cyberpunk 2077.";
                homepage = "https://github.com/adnksharp/CyberGRUB-2077";
                license = lib.licenses.unlicense;
            };
        }
