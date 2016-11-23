# == Define: caddy::config::server
#
define caddy::config::server (
  $address    = $title,
  $port       = undef,
  $directives = {},
) {
  concat::fragment { "server_${title}":
    target  => $::caddy::caddyfile,
    content => template('caddy/etc/caddy/Caddyfile_server.erb'),
    order   => '02',
  }
}
