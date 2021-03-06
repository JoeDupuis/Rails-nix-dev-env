{
  pgIdentAddress ? "192.168.122.0/24",
  dbName ? "db_name_development",
  dbUser ? "db_user",
  dbPW ? "123123",
  dbSuperAdmin ? true
} :
{

  railsapp-db = {config, pkgs, lib, ...} : {
    environment.systemPackages = with pkgs; [
      htop
      tmux
      telnet
    ];

    networking.firewall.allowedTCPPorts = [ 5432 6379 ];

    services.redis = {
      enable = true;
      bind = "0.0.0.0";
    };

    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      package = pkgs.postgresql_11;

      authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host all all ${pgIdentAddress} md5
    '';

      initialScript = pkgs.writeText "db-initScript" ''
        CREATE ROLE ${dbUser} WITH ${(lib.optionalString dbSuperAdmin "SUPERUSER")} LOGIN PASSWORD '${dbPW}';
      '';
      ensureDatabases = [ dbName ];
      ensureUsers = [{
        name = dbUser;
        ensurePermissions = {
          "DATABASE ${dbName}" = "ALL PRIVILEGES";
        };
      }];
    };

  };

;
}
