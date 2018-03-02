exec { "apt-update":
  command => "/usr/bin/apt-get update"
}
package { ["openjdk-7-jre", "tomcat7"]:
  ensure => installed,
  require => Exec["apt-update"]
}
exec { "apt-get-install-unzip":
  command => "/usr/bin/apt-get install unzip"
}
