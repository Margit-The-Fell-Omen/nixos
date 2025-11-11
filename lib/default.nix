{lib, ...}: let
    requireHostSettings = osConfig: required: result: let
        req =
            if lib.isList required
            then {
                require = required;
                message = "Missing required hostSetting's";
            }
            else required;

        missing = lib.filter (name: !(lib.getAttrFromPath [name "enable"] osConfig.hostSettings or false)) req.require;
    in
        lib.throwIf (missing != []) "${req.message}. Missing: ${lib.concatStringsSep ", " missing}" result;
in {
    inherit requireHostSettings;
}
