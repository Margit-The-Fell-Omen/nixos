{
    config,
    pkgs,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            postgresql = {
                enable = lib.mkEnableOption "PostgreSQL database server";

                port = lib.mkOption {
                    type = lib.types.port;
                    default = 5432;
                    description = "PostgreSQL port";
                };

                databases = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [];
                    example = ["mydb" "testdb"];
                    description = "List of databases to create";
                };

                users = lib.mkOption {
                    type = lib.types.listOf (lib.types.submodule {
                        options = {
                            name = lib.mkOption {
                                type = lib.types.str;
                                description = "Username";
                            };
                            password = lib.mkOption {
                                type = lib.types.str;
                                description = "User password";
                            };
                            databases = lib.mkOption {
                                type = lib.types.listOf lib.types.str;
                                default = [];
                                description = "Databases owned by this user";
                            };
                        };
                    });
                    default = [];
                    example = [
                        {
                            name = "myuser";
                            password = "mypassword";
                            databases = ["mydb"];
                        }
                    ];
                    description = "List of users to create";
                };
            };
        };
    };

    config = let
        cfg = config.hostSettings.postgresql;

        # Генерация SQL для создания пользователей и баз
        usersSql = lib.concatStringsSep "\n" (map (user: ''
            DO $$
            BEGIN
              IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${user.name}') THEN
                CREATE ROLE ${user.name} WITH LOGIN PASSWORD '${user.password}';
              END IF;
            END
            $$;
        '')
        cfg.users);

        databasesSql = lib.concatStringsSep "\n" (map (db: ''
            SELECT 'CREATE DATABASE ${db}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${db}')\gexec
        '')
        cfg.databases);

        ownershipSql = lib.concatStringsSep "\n" (lib.flatten (map (
            user:
                map (db: ''
                    ALTER DATABASE ${db} OWNER TO ${user.name};
                    GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${user.name};
                '')
                user.databases
        )
        cfg.users));

        initialScript = pkgs.writeText "init-postgresql.sql" ''
            ${usersSql}
            ${databasesSql}
            ${ownershipSql}
        '';
    in
        lib.mkIf cfg.enable {
            services.postgresql = {
                enable = true;
                package = pkgs.postgresql_16;

                authentication = pkgs.lib.mkOverride 10 ''
                    # TYPE  DATABASE  USER  ADDRESS       METHOD
                    local   all       postgres            peer
                    local   all       all                 md5
                    host    all       all   127.0.0.1/32  md5
                    host    all       all   ::1/128       md5
                '';

                initialScript = initialScript;

                settings = {
                    listen_addresses = "localhost";
                    port = cfg.port;
                    max_connections = 100;
                    log_connections = true;
                };
            };

            # Добавить psql в системные пакеты
            environment.systemPackages = [pkgs.postgresql_16];
        };
}
