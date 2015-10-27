# == Class suricata::scirius::service
#
class scirius::service {
  service { 'scirius':
    ensure => running,
  }
}

