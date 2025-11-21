{lib, ...}: let
    requireHostSettings = osConfig: required: result: let
        req =
            if builtins.isList required
            then {
                require = required;
                message = "Missing required hostSetting's";
            }
            else required;

        missing = builtins.filter (name: !(lib.getAttrFromPath [name "enable"] osConfig.hostSettings or false)) req.require;
    in
        lib.throwIf (missing != []) "${req.message}. Missing: ${lib.concatStringsSep ", " missing}" result;

    collectDirs = path: (builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir path)));
in {
    inherit requireHostSettings;
    inherit collectDirs;
}
