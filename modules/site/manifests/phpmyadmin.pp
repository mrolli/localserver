# dirty phpmyadmin class
class site::phpmyadmin {
  package { 'phpMyAdmin':
    ensure => present,
  }

  apache::custom_config { 'phpmyadmin.conf':
    source  => 'puppet:///modules/site/phpmyadmin/phpmyadmin.conf',
    require => Package['phpMyAdmin'],
  }

  file { '/etc/phpMyAdmin/config.inc.php':
    ensure  => present,
    owner   => 'root',
    group   => 'apache',
    mode    => '0640',
    source  => 'puppet:///modules/site/phpmyadmin/config.inc.php',
    require => Package['phpMyAdmin'],
  }

  file {'/etc/httpd/conf.d/phpMyAdmin.conf':
    ensure => absent,
    notify => Service['httpd'],
  }
}

