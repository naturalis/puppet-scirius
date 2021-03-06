# == Class scirius::config
#
class scirius::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # prepare start scripts
  file { 'scirius init':
    path    => '/etc/init.d/scirius',
    content => template('scirius/scirius.init.erb'),
    mode    => '0755',
  }
  file { 'scirius default':
    path   => '/etc/default/scirius',
    source => 'puppet:///modules/scirius/scirius.default',
  }
  file { 'scirius manage':
    path    => '/opt/scirius/manage.py',
    mode    => '0755',
    require => Vcsrepo['/opt/scirius'],
  }

  # only trigger creation of users, sources, rulesets if new db is created
  exec { 'scirius_admin_user':
    command     => '/usr/bin/expect create_scirius_user.exp',
    refreshonly => true,
    cwd         => '/opt/scirius',
    subscribe   => [ File['create scirius expect'], Exec['initial_syncdb'] ],
  }
  exec { 'scirius_ruleset':
    command     => "/usr/bin/python manage.py addsource ${scirius::params::scirius_ruleset_name} ${scirius::params::scirius_ruleset_url} http sigs",
    refreshonly => true,
    cwd         => '/opt/scirius',
    subscribe   => [ File['create scirius expect'], Exec['initial_syncdb'] ],
  }
  exec { 'scirius_defaultruleset':
    command     => "/usr/bin/python manage.py defaultruleset ${scirius::params::scirius_ruleset_name}",
    refreshonly => true,
    cwd         => '/opt/scirius',
    subscribe   => Exec['scirius_ruleset'],
  }
  exec { 'scirius_addsuricata':
    command     => "/usr/bin/python manage.py addsuricata ${::hostname} 'Puppet installed' /etc/suricata/rules/${scirius::params::scirius_ruleset_name} ${scirius::params::scirius_ruleset_name}",
    refreshonly => true,
    cwd         => '/opt/scirius',
    subscribe   => Exec['scirius_defaultruleset'],
  }
  exec { 'scirius_updatesuricata':
    command     => '/usr/bin/python manage.py updatesuricata',
    refreshonly => true,
    cwd         => '/opt/scirius',
    subscribe   => Exec['scirius_addsuricata'],
  }

  # auto update ruleset daily
  if $scirius::params::scirius_ruleset_update == true {
    cron { 'update rules':
      command => 'cd /opt/scirius;/usr/bin/python manage.py updatesuricata',
      user    => root,
      special => daily,
    }

    @sensu::check { 'update IDS ruleset' :
      command => '/usr/local/bin/check_file_age.sh  /etc/suricata/rules/ETpro/scirius.rules 1500 3000',
      tag     => 'central_sensu',
    }
  }

  # reload suricata on new ruleset
  cron { 'auto reload suricata':
    command => "[ -f /etc/suricata/rules/${scirius::params::scirius_ruleset_name}/scirius.reload ] && service suricata restart;rm /etc/suricata/rules/${scirius::params::scirius_ruleset_name}/scirius.reload",
    user    => root,
    minute  => '*',
  }
}

