# == Class: example_class
#
# This class creates a zabbix server with local database and local frontend.
#
# === Parameters
#
# [*zabbix_url*]
# Apache virtual host where zabbix is served.
# [*database_type*]
# Database provider(for now only mysql supported).
# [*database_user*]
# Database user.
# [*database_password*]
# Database password.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#
class admin::monitoring::zabbix::server(
$zabbix_url,
$database_type,
$database_user = undef,
$database_password = undef
) {
  class { '::zabbix':
    zabbix_url        => $zabbix_url,
    database_type     => $database_type,
    database_user     => $database_user,
    database_password => $database_password,
  }
}
