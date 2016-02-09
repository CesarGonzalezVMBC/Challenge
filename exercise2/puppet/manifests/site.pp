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

package {'libapache2-mod-php5':
                ensure  => installed,
				notify  => Service['apache2'],
				require => Package['apache2'],
        }

package {'php5-mysql':
                ensure  => installed,
				notify  => Service['apache2'],
				require => Package['apache2'],
        }

		
file {'/etc/apache2/mods-available/php5.conf':
                require => Package["apache2"],
                notify => Service["apache2"],
        }

 service { "apache2":
    ensure  => "running",
	require => Package["apache2"],
  }	

exec { "reload-apache2":
      command => "/etc/init.d/apache2 reload",
      refreshonly => true,
   }
}

class mysql {
	 package { "mysql-server-5.1":
    ensure => present
  }
 
  service { "mysql":
    ensure => running,
    require => Package["mysql-server-5.1"]
  }
 
  exec { "create-db-schema-and-user":
    command => "/usr/bin/mysql -u root -p -e \"drop database if exists wordpress_db; create database wordpress_db; create user 'wordpress_user'@'localhost' identified by 'wordpress'; grant all on *.* to 'wordpress_user'@'localhost'; flush privileges;\"",
    require => Service["mysql"],
  }
 
}

class webserver {
	
	file { "/etc/apache2/sites-available/site.conf":
		source  => '/vagrant/puppet/files/site.conf',
		notify => Service["apache2"],
		require => Package["apache2"],
	}
	
	exec { "configsite":
			   path    => "/usr/bin:/usr/sbin:/bin",
			   command => "/usr/sbin/a2ensite site.conf",
               notify  => Service["apache2"],
               require => Package["apache2"],
            }    
}

class wordpressinstall {
	package { "wget":
		ensure  => present,
	}
	
	$install_dir = '/vagrant/www/wp'

	exec {"mkdir":
		command => "sudo mkdir /vagrant/www/wp -p"
	}

	file { "${install_dir}":
		ensure  => directory,
		recurse => true,
	}

	file { "${install_dir}/wp-config-sample.php":
		ensure => present,
		require => Package["apache2"]
	}
	
	exec { 'Download wordpress':
		command => "wget http://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz --no-check-certificate",
		creates => "/tmp/wp.tar.gz",
		require => [ File["${install_dir}"], Package["wget"] ],
	} ->
	exec { 'Extract wordpress':
		command => "sudo tar zxvf /tmp/wp.tar.gz --strip-components=1 -C ${install_dir}",
		creates => "${install_dir}/index.php",
		require => Exec["Download wordpress"],
	} ->
	exec { "copy_def_config":
		command => "sudo cp ${install_dir}/wp-config-sample.php ${install_dir}/wp-config.php",
		creates => "${install_dir}/wp-config.php",
		require => File["${install_dir}/wp-config-sample.php"],
	} ->
	file_line { 'db_name_line':
		path  => "${install_dir}/wp-config.php",
		line  => "define('DB_NAME', 'wordpress_db');",
		match => "^define\\('DB_NAME*",
	} ->
	file_line { 'db_user_line':
		path  => "${install_dir}/wp-config.php",
		line  => "define('DB_USER', 'wordpress_user');",
		match => "^define\\('DB_USER*",
	} ->
	file_line { 'db_password_line':
		path  => "${install_dir}/wp-config.php",
		line  => "define('DB_PASSWORD', 'wordpress');",
		match => "^define\\('DB_PASSWORD*",
	} ->
	file_line { 'db_host_line':
		path  => "${install_dir}/wp-config.php",
		line  => "define('DB_HOST', 'localhost');",
		match => "^define\\('DB_HOST*",
	} ->
	file_line { 'wp_lang':
		path  => "${install_dir}/wp-config.php",
		line  => "define('WP_LANG', 'en_US');",
		match => "^define\\('WP_LANG*",
	} ->
	file_line { 'wp_site_domain_':
		path  => "${install_dir}/wp-config.php",
		line  => "define('WP_SITE_DOMAIN', 'local.com');",
		match => "^define\\('WP_SITE_DOMAIN*",
	} ~>
	exec { 'Change ownership':
		command     => "sudo chown -R wwwrun:www ${install_dir}",
		require => Exec["Extract wordpress"],
		refreshonly => true,
	}
}

include apache
include mysql
include webserver
include system-update
include wordpressinstall
