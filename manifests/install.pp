# == Class: caddy::install
#
class caddy::install {
  include ::archive

  file { $::caddy::install_path:
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
  }

  archive { "/tmp/${caddy::params::release_file_name}":
    ensure        => present,
    extract       => true,
    extract_path  => $caddy::params::install_path,
    source        => $caddy::params::download_url,
    # checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    # checksum_type => 'sha1',
    creates       => "${caddy::params::install_path}/caddy_linux_amd64",
    cleanup       => true,
    require       => File[$::caddy::install_path],
    user          => 'root',
    group         => 'root',
  }

  file { '/usr/local/bin/caddy':
    ensure  => link,
    mode    => '0755',
    target  => "${caddy::params::install_path}/caddy_linux_amd64",
    owner   => 'root',
    group   => 'root',
    require => Archive["/tmp/${caddy::params::release_file_name}"]
  }
}
