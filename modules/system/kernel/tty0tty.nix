{
    fetchFromGitHub,
    kernel,
    ...
}: let
    stdenv = kernel.stdenv;
in
    stdenv.mkDerivation rec {
        pname = "tty0tty";
        version = "04b53bb3fe504f13074a14642ff5e06ac0bf5ef5";

        src = fetchFromGitHub {
            owner = "freemed";
            repo = "tty0tty";
            rev = "${version}";
            hash = "sha256-Bb5nqP4T4FjqY6V3P6rQDXnjf67tWe31sh/RrLx6m4g=";
        };

        sourceRoot = "${src.name}/module";
        hardeningDisable = ["pic" "format"];
        nativeBuildInputs = kernel.moduleBuildDependencies;

        postPatch = ''
            # patch out because udev rules are managed through nix
            rm -f 50-tty0tty.rules
            substituteInPlace Makefile --replace-fail "install -m 644 50-tty0tty.rules /etc/udev/rules.d" ""

            # HACK: patch out so there's no division by zero error
            sed -i '/tty_get_baud_rate/{
                a\	if (!baud_rate) baud_rate = 115200;
            }' tty0tty.c
        '';

        makeFlags = [
            # uses gcc by default, need
            "CC=${stdenv.cc}/bin/cc"
            "LD=${stdenv.cc}/bin/ld"

            "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
            "INSTALL_MOD_PATH=$(out)"
        ];

        installTargets = ["modules_install"];
    }
