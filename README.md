# puppet-caddy

## Description

Puppet module to setup Caddy web server

## Setup

### Requirements

This module has the following module dependencies:

- archive: https://forge.puppet.com/puppet/archive
- concat: https://forge.puppet.com/puppetlabs/concat
- stdlib: https://forge.puppet.com/puppetlabs/stdlib

## Usage

In order to use the caddy module, just include it in your manifest. You can configure everything from hiera.

To configure the caddy module, just take a look at the parameters in [`manifests/init.pp`](manifests/init.pp).

To setup a custom server / virtual host, you have to define a `caddy::servers` hiera hash, where the keys of the hash are the server addresses, and the parameters are:

- `port` (optional): the server will be listening to this port
- `directives` (optional): all the specific directives that the server have to contain.

Take a look at the [Caddyfile documentation](https://caddyserver.com/docs/caddyfile), to know how the server address can be specified, and to have more information on all the directives that can be specified.

Take into account that `caddy::default_address` and `caddy::default_port` can't be defined together with `caddy::servers`. If you only need a single virtual host, you might go for the `default_address` and `default_port` setup, but most of the times you'll go for the `caddy::servers` hash as it's the most dynamic solution.

### Example

In your puppet code:

```
node default {
  include ::caddy
}
```

In hiera data:

```yaml
---
  caddy::default_directives:
    log: '/var/log/access.log'

  caddy::servers:
    'www.caddy.com':
      gzip: ''
      'markdown /blog':
        css: '/blog.css'
        js: '/scripts.js'

```
