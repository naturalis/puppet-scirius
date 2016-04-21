# == Class suricata::scirius::service
#
class scirius::service {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # start scirius service
  service { 'scirius':
    ensure    => running,
    hasstatus => false,
    pattern   => '/usr/bin/python /opt/scirius/manage.py',
  }
}

