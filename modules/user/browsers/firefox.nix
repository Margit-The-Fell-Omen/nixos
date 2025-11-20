{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            browsers.firefox.enable = lib.mkEnableOption "Firefox";
        };
    };

    config = lib.mkIf config.userSettings.browsers.firefox.enable {
        programs.firefox = {
            enable = true;
            profiles.default = {
                isDefault = true;
                preConfig = builtins.readFile "${pkgs.arkenfox-userjs}/user.js";
                settings = {
                    ## arkenfox user.js overrides
                    # restore previous session
                    "browser.startup.page" = 3;

                    # re-enable captive portal detection (may be useful sometimes)
                    # "captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
                    # "network.captive-portal-service.enabled" = true;

                    # don't send pings
                    # see https://www.bleepingcomputer.com/news/software/major-browsers-to-prevent-disabling-of-click-tracking-privacy-risk
                    "browser.send_pings" = false;

                    # use DoH
                    "network.trr.mode" = 3;
                    "network.trr.uri" = "https://1.1.1.1/dns-query";
                    "network.trr.custom_uri" = "https://1.1.1.1/dns-query";

                    # allow search suggestions
                    "browser.search.suggest.enabled" = true;
                    "browser.urlbar.suggest.searches" = true;

                    # allow autofilling forms
                    "browser.formfill.enable" = true;

                    # enable disk caching
                    "browser.cache.disk.enable" = true;

                    # ?
                    "browser.sessionstore.privacy_level" = 2;

                    # ?
                    "network.IDN_show_punycode" = false;

                    # use downloads directory instead of asking every time
                    "browser.download.useDownloadDir" = true;
                    # don't ask about new mimetypes
                    "browser.download.always_ask_before_handling_new_types" = false;

                    # keep data on shutdown
                    "privacy.sanitize.sanitizeOnShutdown" = false;
                    "privacy.clearOnShutdown_v2.formdata" = false;
                    "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;

                    # relax FPP a bit due to usability concerns
                    # `-JSDateTimeUTC` doesn't reset timezone to UTC+0
                    # `-CSSPrefersColorScheme` allows for sites to detect colorscheme preferences
                    "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";

                    # otherwise addons are needed to be enabled manually after first install
                    # "extensions.autoDisableScopes" = 0;
                };
                search = {
                    default = "ddg";
                    privateDefault = "ddg";
                    engines = {
                        bing.metaData.hidden = true;
                        google.metaData.hidden = true;
                        ecosia.metaData.hidden = true;
                        perplexity.metaData.hidden = true;
                        wikipedia.metaData.hidden = true;
                    };
                    force = true;
                };
                extensions = {
                    packages = with pkgs.firefoxAddons; [
                        ublock-origin
                        privacy-badger17
                        consent-o-matic
                        skip-redirect
                    ];
                };
            };
        };

        stylix.targets.firefox.profileNames = ["default"];
    };
}
