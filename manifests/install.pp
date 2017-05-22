# == Class: caddy::install
#
class caddy::install {
  if $::caddy::manage_user {
    user { $::caddy::user:
      ensure  => present,
      comment => 'Caddy user',
      home    => '/var/www',
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
        ensure       => present,
        extract      => true,
        extract_path => $::caddy::install_path,
        source       => $::caddy::archive_download_url ? {
          undef   => "https://github.com/mholt/caddy/releases/download/v${::caddy::version}/${::caddy::release_file_name}",
          default => $::caddy::archive_download_url
        },
        # checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
        # checksum_type => 'sha1',
        creates      => "${::caddy::install_path}/${::caddy::real_bin_file_name}",
        cleanup      => true,
        require      => File[$::caddy::install_path],
        user         => 'root',
        group        => 'root',
      }

      exec { 'root permission':
        command     => "/bin/chown -R root:root ${::caddy::install_path}",
        subscribe   => Archive[$::caddy::archive_file],
        refreshonly => true
      }
    }
    'source' : {
      $go_install_cmd = "${::golang::base_dir}/bin/go get github.com/mholt/caddy/caddy"
      exec { $go_install_cmd:
        environment => [
          "GOPATH=${::golang::workdir}",
          "GOROOT=${::golang::base_dir}"
        ],
        creates     => "${::caddy::install_path}/${::caddy::real_bin_file_name}",
        require     => Class['golang::install']
      }
    }
  }

  if "${::caddy::install_path}/${::caddy::real_bin_file_name}" != '/usr/local/bin/caddy' {
    file { '/usr/local/bin/caddy':
      ensure  => link,
      mode    => '0755',
      target  => "${::caddy::install_path}/${::caddy::real_bin_file_name}",
      owner   => 'root',
      group   => 'root',
      require => $::caddy::install_method ? {
        'source'  => Exec[$go_install_cmd],
        'archive' => Archive[$::caddy::archive_file]
      }
    }
  }

  # Create the folder where the ssl certificates will be
  file { $::caddy::certificates_path:
    ensure => directory,
    mode   => '0750',
    owner  => $::caddy::user,
    group  => $::caddy::group
  }

  # Allow caddy web server to listen on privileged ports (< 1024)
  exec { 'setcap':
    command   => "setcap cap_net_bind_service=+ep ${::caddy::install_path}/${::caddy::real_bin_file_name}",
    path      => ['/sbin', '/usr/sbin', '/bin', '/usr/bin', ],
    subscribe => $::caddy::install_method ? {
      'source'  => Exec[$go_install_cmd],
      'archive' => Archive[$::caddy::archive_file]
    },
    unless    => "getcap ${::caddy::install_path}/${::caddy::real_bin_file_name} | grep cap_net_bind_service+ep",
  }

  Exec['root permission'] -> Exec['setcap']
}
