# https://github.com/indygreg/collectd-carbon
class collectd::plugin::carbon_writer (
  $ensure            = present,
  $graphitehost      = 'localhost',
  $graphiteport      = 2003,
  $storerates        = true,
  $graphiteprefix    = 'collectd.',
  $graphitepostfix   = undef,
  $interval          = undef,
  $escapecharacter   = '_',
  $alwaysappendds    = false,
  $protocol          = 'tcp',
  $separateinstances = false,
  $logsenderrors     = true,
) {
  validate_bool($storerates)
  validate_bool($separateinstances)
  validate_bool($logsenderrors)

  file {'/opt/collectd-plugins':
    ensure => directory,
  }

  file { '/opt/collectd-plugins/carbon_writer.py':
    ensure  => present,
    source  => 'puppet:///modules/collectd/carbon_writer.py',
    require => File['/opt/collectd-plugins'],
  }

  collectd::plugin {'carbon_writer':
    ensure   => $ensure,
    content  => template('collectd/plugin/carbon_writer.conf.erb'),
    interval => $interval,
    require  => File['/opt/collectd-plugins/carbon_writer.py'],
  }
}
