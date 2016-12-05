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
  $install_method     = $::caddy::params::install_method
) inherits caddy::params {
  if $install_method == 'source' and !defined(Class['golang']) {
    class { 'golang':
      repo_version => 'go1.7'
    }
  }

  $install_path = $install_method ? {
    'source'  => "${::golang::workdir}bin",
    'archive' => "${::caddy::params::install_path}",
  }

  $bin_file_name = $install_method ? {
    'source'  => 'caddy',
    'archive' => "${::caddy::params::bin_file_name}",
  }

  include caddy::install
  include caddy::config
  include caddy::service

  Class['caddy::install'] -> Class['caddy::config']
  Class['caddy::config'] ~> Class['caddy::service']
}
