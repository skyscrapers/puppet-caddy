# == Class: caddy::install
#
class caddy::install {
  if $::caddy::manage_user {
    user { $::caddy::user:
      comment => 'Caddy user',
      home    => '/var/www',
      ensure  => present,
      shell   => '/usr/sbin/nologin',
      gid     => $::caddy::group,
    }
  }

  if $::caddy::manage_group {
    group { $::caddy::group:
      ensure => present
    }
  }

  case $::caddy::install_method {
    'archive': {
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
    'source' : {
      include ::golang

      exec { "${golang::base_dir}/bin/go get github.com/mholt/caddy":
        environment => [
          "GOPATH=${golang::workdir}",
          "GOROOT=${golang::base_dir}"
        ],
        creates => "${golang::workdir}bin/caddy",
        require => Class['golang::install']
      }
    }
  }

  # Create the folder where the ssl certificates will be
  file { $::caddy::certificates_path:
    ensure  => directory,
    mode    => '0750',
    owner   => $::caddy::user,
    group   => $::caddy::group
  }

  # Allow caddy web server to listen on privileged ports (< 1024)
  exec { "setcap cap_net_bind_service=+ep ${::caddy::install_path}/caddy_linux_amd64":
    path      => ['/sbin', '/usr/sbin', '/bin', '/usr/bin', ],
    subscribe => Archive[$::caddy::archive_file],
    unless    => "getcap ${::caddy::install_path}/caddy_linux_amd64 | grep cap_net_bind_service+ep",
  }

}
