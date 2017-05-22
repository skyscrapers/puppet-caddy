# == Class: caddy::service
#
class caddy::service {
  $service_file = '/lib/systemd/system/caddy.service'
  file { $service_file:
    ensure  => present,
    mode    => '0744',
    content => template('caddy/lib/systemd/system/caddy.service.erb'),
    owner   => 'root',
    group   => 'root'
  }

  exec { 'caddy-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  service { $::caddy::service_name:
    ensure    => running,
    enable    => true,
    require   => File[$service_file]
  }

  File[$service_file] ~> Exec['caddy-systemd-reload'] ~> Service[$::caddy::service_name]
}
