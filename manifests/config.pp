# == Class: caddy::config
#
class caddy::config (
) {
  file { $::caddy::config_path:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }

  # TODO: test config or make service fail when there's an error
  concat { $::caddy::caddyfile:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => File[$::caddy::config_path],
    ensure_newline => true
  }

  create_resources('caddy::config::server', hiera_hash('caddy::servers', {}), {})
}
