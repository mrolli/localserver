### MySQL Server
$override_options = {
  'client'                  => {
    'default-character-set' => 'utf8',
  },
  'mysqld'                  => {
    'bind-address'          => '0.0.0.0',
    'character-set-server'  => 'utf8',
    'collation-server'      => 'utf8_general_ci',
  }
}

class { '::mysql::server':
  root_password           => '123456',
  restart                 => true,
  remove_default_accounts => true,
  override_options        => $override_options,
}

### Apache Webserver incl. PHP
class { '::apache':  }
include ::apache::mod::php

augeas { 'php.ini':
  notify  => Service[httpd],
  require => Class[::apache::mod::php],
  changes => [
    'set /files/etc/php.ini/PHP/post_max_size 32M',
    'set /files/etc/php.ini/PHP/upload_max_filesize 32M',
    'set /files/etc/php.ini/Session/session.gc_maxlifetime 14400',
  ];
}

### phpMyAdmin
include ::site::phpmyadmin

### Resource dependencies
Class['::mysql::server']->
Class['::apache']->
Class['::site::phpmyadmin']

ssh_authorized_key { 'michael@rollis.ch':
  user => 'root',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCjLkvYHLLXw6vmGoIyRsJCJTLx+N+IP1wXnHvoLIjfyNMNkhrLW7uGU+C+lagGX7DgfaFdQMV9HjJkubpSH+Qd69QBDWy7WBIxSQvL/7mzGpQB7dWfg/28AQYRS56nU/qb9C0kBmxVz6IjsIq2WQnjn309zOmSqo5N/9N+mo+08l4E9+2zxsC2WQ8ufRJMHU75IjM3xWAdD4Ou05ab/s6Bj1DA7bkhpoIQeJ1pR+a/Kig/dt7Tcp+U5ThfxTLDWdnFWPc2kRurkd35kX/Au6HZMooRQl9S8KSsJiYKIG4BP3vVnGxooJOlr6e8wOtQ0/y7Fo5CEJEpMyEYb7IpJp93',
}
