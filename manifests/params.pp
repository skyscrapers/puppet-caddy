# == Class: caddy::params
#
class caddy::params {
  $version = '0.9.3'
  # TODO: support multiple architectures (386 and 64 bit)
  # TODO: support multiple os
  $bin_file_name = 'caddy_linux_amd64'
  $release_file_name = 'caddy_linux_amd64.tar.gz'
  $install_path = '/opt/caddy'
  $archive_file = "/tmp/${release_file_name}"
  # TODO: support multiple service providers
  $service_name = 'caddy'

  $config_path = '/etc/caddy'
  $caddyfile = "${config_path}/Caddyfile"

  $user = 'www-data'
  $group = 'www-data'
  $certificates_path = '/etc/ssl/caddy'

  # Allowed values: archive, source
  $install_method = 'archive'
}
