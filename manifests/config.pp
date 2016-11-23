# == Class: caddy::config
#
class caddy::config {
  file { $::caddy::config_directory:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }

  concat { $::caddy::caddyfile_path:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => File[$::caddy::config_directory],
  }

  concat::fragment { 'init':
    target  => $::caddy::caddyfile_path,
    content => template('caddy/etc/caddy/Caddyfile.erb'),
    order   => '01',
  }

  create_resources('caddy::config::server', hiera_hash('caddy::servers', {}), {})
}
