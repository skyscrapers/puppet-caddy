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
  $version            = $::caddy::params::version,
  $manage_user        = true,
  $manage_group       = true,
  $user               = $::caddy::params::user,
  $group              = $::caddy::params::group,
) inherits caddy::params {
  include caddy::install
  include caddy::config
  include caddy::service

  # TODO: check that servers and default_address or port are not defined together
  Class['caddy::install'] -> Class['caddy::config']
  Class['caddy::config'] ~> Class['caddy::service']
}
