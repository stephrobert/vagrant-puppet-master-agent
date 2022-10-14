# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include apache2
class apache2 ( String $content ) {
  if $facts['os']['family'] != 'Debian' {
    notice("This os  ${facts['os']['name']} is not supported")
  }
  else {
    file_line { 'sudo_rule':
      path => '/etc/sudoers',
      line => '%sudo ALL=(ALL) ALL',
    }
    # Installation de apache
    package { 'apache2':
      ensure => 'present',
    }
    # On démarre le service apache
    service { 'apache2':
      ensure => 'running',
    }
    file { '/var/www/html/index.html':
      ensure  => 'file',
      content => $content,
      path    => '/var/www/html/index.html',
    }
  }
}
