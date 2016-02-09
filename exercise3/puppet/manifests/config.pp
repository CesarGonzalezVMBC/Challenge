group { "puppet":
  ensure => "present",
}

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class system-update {
  exec { 'apt-get update':
  command => 'apt-get update',
  }

  $sysPackages = [ "build-essential" ]
  package { $sysPackages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }
}

class apache {
  package { "apache2":
    ensure  => present,
    require => Class["system-update"],
  }

  service { "apache2":
	ensure => stopped,
	require => Package["apache2"]
	}
}

class mysql {
	package { "mysql-server-5.1":
    ensure => present
  }
 
  service { "mysql":
    ensure => stopped,
    require => Package["mysql-server-5.1"]
  }
  
 exec {'conf':
	command => "sudo sed -i \"s/.*bind-address.*/bind-address = 0.0.0.0/\" /etc/mysql/my.cnf"
 }
 
}

include apache
include mysql
include system-update
