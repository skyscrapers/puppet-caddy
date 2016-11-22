# == Class: caddy
#
# === Parameters
#
# Document parameters here.
#
# version
#   Release of the Caddy web server to install
#   Defaults to 0.9.3
#
class caddy (
  $version = $caddy::params::version
) inherits caddy::params {
  include caddy::install
  include caddy::config
  include caddy::service

  Class['caddy::install'] -> Class['caddy::config']
  Class['caddy::config'] ~> Class['caddy::service']
}
