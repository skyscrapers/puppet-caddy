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

To setup a server / virtual host, you have to define a `caddy::servers` hiera hash, where the keys of the hash are the server addresses, and the parameters are:

- `port` (optional): the server will be listening to this port
- `directives` (optional): all the specific directives that the server have to contain.

Take a look at the [Caddyfile documentation](https://caddyserver.com/docs/caddyfile), to know how the server address can be specified, and to have more information on all the directives that can be specified.

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
  caddy::servers:
    'www.caddy.com':
      directives:
        log: 'stdout'
        gzip: ''
        'markdown /blog':
          css: '/blog.css'
          js: '/scripts.js'

```

For setups managed by `systemd`, try to use `log stdout` and `errors stderr` as much as possible for the logs to end up in `journald`.
With `journalctl` it is quite easy to search for specific log entries in a unified way.

E.g. search for LetsEncrypt rate limiting messages in the last 5 days:

`$ journalctl -u caddy -p err --since "5 days ago"`
