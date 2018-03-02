exec { "apt-update":
  command => "/usr/bin/apt-get update"
}
package { ["openjdk-7-jre", "tomcat7", "mysql-server"]:
  ensure => installed,
  require => Exec["apt-update"]
}
exec { "apt-get-install-unzip":
  command => "/usr/bin/apt-get install unzip"
}
service { "tomcat7":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Package["tomcat7"]
}
service { "mysql":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Package["mysql-server"]
}
file { "/var/lib/tomcat7/webapps/vraptor-musicjungle.war":
    source => "/vagrant/.vagrant/manifests/vraptor-musicjungle.war",
    owner => "tomcat7",
    group => "tomcat7",
    mode => 0644,
    require => Package["tomcat7"],
    notify => Service["tomcat7"]
}
exec { "musicjungle":
    command => "mysqladmin -uroot create musicjungle",
    unless => "mysql -u root musicjungle",
    path => "/usr/bin",
    require => Service["mysql"]
}
exec {"user":
    command => "mysql -uroot -e \"GRANT ALL PRIVILEGES ON * TO 'musicjungle'@'%' IDENTIFIED BY 'minha-senha';\" musicjungle",
    unless => "mysql -u musicjungle musicjungle"
    path => "/usr/bin",
    require => Service["mysql"]
}
