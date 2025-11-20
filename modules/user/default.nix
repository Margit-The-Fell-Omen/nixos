{lib, ...}: let
    # recursively constructs a mapping of files to types
    getDir = dir:
        lib.mapAttrs (file: type:
            if type == "directory"
            then getDir "${dir}/${file}"
            else type) (builtins.readDir dir);

    # collects all files of a directory as path strings
    files = dir: lib.collect lib.isString (lib.mapAttrsRecursive (path: type: lib.concatStringsSep "/" path) (getDir dir));

    # imports all files that end with `.nix`, except this one and ones ending in `-hm.nix`
    importAll = dir: map (file: ./${file}) (lib.filter (file: lib.hasSuffix ".nix" file && file != "default.nix" && ! lib.hasSuffix "-hm.nix" file && ! lib.hasSuffix "-config.nix" file) (files dir));
in {
    imports = importAll ./.;
}
