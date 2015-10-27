# == Class suricata::scirius::service
#
class suricata::scirius::service {
  service { 'scirius service':
    ensure => running,
  }
}

