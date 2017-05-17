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
  $archive_download_url = undef,
  $log_path             = $::caddy::params::log_path,
) inherits caddy::params {

  $release_file_name    = versioncmp('0.9.99', $version) ? {
    1 => 'caddy_linux_amd64.tar.gz',
    default => "caddy_v${version}_linux_amd64.tar.gz"
  }
  $archive_file         = "/tmp/${release_file_name}"

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
    'archive' => versioncmp('0.9.99', $version)? {
      1 => 'caddy_linux_amd64',
      default => 'caddy'
    },
  }

  include caddy::install
  include caddy::config
  include caddy::service

  Class['caddy::install'] -> Class['caddy::config']
  Class['caddy::install'] ~> Class['caddy::service']
  Class['caddy::config'] ~> Class['caddy::service']
}
