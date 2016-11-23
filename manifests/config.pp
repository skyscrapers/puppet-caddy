# == Class: caddy::config
#
class caddy::config {
  file { $::caddy::config_directory:
    ensure  => directory,
    owner   => 'root',
    group   => 'root'
  }

  file { $::caddy::caddyfile_path:
    ensure  => file,
    mode    => '0644',
    content => template('caddy/etc/caddy/Caddyfile.erb'),
    owner   => 'root',
    group   => 'root',
    require => File[$::caddy::config_directory]
  }
}
