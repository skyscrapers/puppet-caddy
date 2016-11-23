# == Class: caddy::service
#
class caddy::service {
  $service_file = '/lib/systemd/system/caddy.service'
  file { $service_file:
    ensure  => link,
    mode    => '0744',
    target  => "${::caddy::install_path}/init/linux-systemd/caddy.service",
    owner   => 'root',
    group   => 'root',
    require => Archive[$::caddy::archive_file]
  }

  file_line { 'caddy_user':
    ensure  => present,
    path    => $service_file,
    line    => "User=${::caddy::user}",
    match   => '^User\=',
    require => File[$service_file]
  }

  file_line { 'caddy_group':
    ensure  => present,
    path    => $service_file,
    line    => "Group=${::caddy::group}",
    match   => '^Group\=',
    require => File[$service_file]
  }

  service { $::caddy::service_name:
    ensure  => running,
    enable  => true,
    require => [
      File[$service_file],
      File_line['caddy_user'],
      File_line['caddy_group']
    ]
  }

  File[$service_file] ~> Service[$::caddy::service_name]
  File_line['caddy_user'] ~> Service[$::caddy::service_name]
  File_line['caddy_group'] ~> Service[$::caddy::service_name]
}
