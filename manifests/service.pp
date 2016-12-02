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

  service { $::caddy::service_name:
    ensure    => running,
    enable    => true,
    require   => File[$service_file],
    subscribe => File[$service_file]
  }
}
