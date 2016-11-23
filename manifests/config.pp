# == Class: caddy::config
#
class caddy::config (
  $default_address    = $::caddy::default_address,
  $default_port       = $::caddy::default_port,
  $default_directives = $::caddy::default_directives
) {
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
    ensure_newline => true
  }

  if $default_address != undef or $default_port != undef { # This is to avoid a puppet warning when the template is empty
    concat::fragment { 'init':
      target  => $::caddy::caddyfile_path,
      content => template('caddy/etc/caddy/Caddyfile.erb'),
      order   => '01',
    }
  }

  concat::fragment { 'default_directives':
    target  => $::caddy::caddyfile_path,
    content => template('caddy/etc/caddy/Caddyfile_default_directives.erb'),
    order   => '99',
  }

  create_resources('caddy::config::server', hiera_hash('caddy::servers', {}), {})
}
