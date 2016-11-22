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

  archive { $::caddy::archive_file:
    ensure        => present,
    extract       => true,
    extract_path  => $::caddy::install_path,
    source        => $::caddy::download_url,
    # checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    # checksum_type => 'sha1',
    creates       => "${::caddy::install_path}/caddy_linux_amd64",
    cleanup       => true,
    require       => File[$::caddy::install_path],
    user          => 'root',
    group         => 'root',
  }

  exec { 'root permission':
    command     => "/bin/chown -R root:root ${::caddy::install_path}",
    subscribe   => Archive[$::caddy::archive_file],
    refreshonly => true
  }

  file { '/usr/local/bin/caddy':
    ensure  => link,
    mode    => '0755',
    target  => "${::caddy::install_path}/caddy_linux_amd64",
    owner   => 'root',
    group   => 'root',
    require => Archive[$::caddy::archive_file]
  }
}
