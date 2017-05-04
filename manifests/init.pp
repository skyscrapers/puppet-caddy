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
  $version              = $::caddy::params::version,
  $manage_user          = true,
  $manage_group         = true,
  $user                 = $::caddy::params::user,
  $group                = $::caddy::params::group,
  $install_method       = $::caddy::params::install_method,
  $release_file_name    = $::caddy::params::release_file_name,
  $archive_download_url = undef,
  $bin_file_name        = $::caddy::params::bin_file_name,
  $log_path             = $::caddy::params::log_path,
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

  $real_bin_file_name = $install_method ? {
    'source'  => 'caddy',
    'archive' => $bin_file_name,
  }

  include caddy::install
  include caddy::config
  include caddy::service

  Class['caddy::install'] -> Class['caddy::config']
  Class['caddy::install'] ~> Class['caddy::service']
  Class['caddy::config'] ~> Class['caddy::service']
}
