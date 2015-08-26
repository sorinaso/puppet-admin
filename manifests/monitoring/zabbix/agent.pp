# == Class:
#
# Create a zabbix agent node.
#
# === Parameters
#
# [*server_ip*]
# Zabbix server ip(the agent node listen connections only from this ip.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#
class admin::monitoring::zabbix::agent(
$server_ip,
) {
  class { '::zabbix::agent':
    server    => $server_ip,
    listenip  => $server_ip,
  }
}
