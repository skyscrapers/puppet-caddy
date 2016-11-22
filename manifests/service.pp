# == Class: caddy::service
#
class caddy::service {
  file { '/lib/systemd/system/caddy.service':
    ensure  => link,
    mode    => '0744',
    target  => "${::caddy::install_path}/init/linux-systemd/caddy.service",
    owner   => 'root',
    group   => 'root',
    require => Archive["/tmp/${::caddy::release_file_name}"]
  }

  service { $::caddy::service_name:
    ensure  => running,
    enable  => true,
    require => File['/lib/systemd/system/caddy.service']
  }
}
