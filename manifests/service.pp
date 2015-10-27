# == Class suricata::scirius::service
#
class scirius::service {
  service { 'scirius':
    ensure    => running,
    hasstatus => false,
    pattern   => '/usr/bin/python /opt/scirius/manage.py',
  }
}

