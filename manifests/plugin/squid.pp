# https://github.com/indygreg/collectd-carbon
class collectd::plugin::squid (
  $ensure            = present,
) {

  #ensure_resource('file', '/opt/collectd-plugins', {
  #  ensure => directory,
  #})
  file {'/opt/collectd-plugins':
    ensure => directory,
  }

  file { '/opt/collectd-plugins/squid.sh':
    ensure  => present,
    source  => 'puppet:///modules/collectd/squid.sh',
    mode    => '0555',
    owner   => root,
    group   => root,
    require => File['/opt/collectd-plugins'],
  }

  collectd::plugin { 'squid':
    ensure   => $ensure,
    content  => template('collectd/plugin/squid.conf.erb'),
    interval => $interval,
    require  => File['/opt/collectd-plugins/squid.sh'],
  }
}
