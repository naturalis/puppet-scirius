# == Class scirius::config
#
class scirius::config {
  # install packages
  $packages = [
    'expect',
  ]
  ensure_packages($packages)

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
  }
  cron { 'auto reload suricata':
    command => "[ -f /etc/suricata/rules/${scirius::params::scirius_ruleset_name}/scirius.reload ] && service suricata restart;rm /etc/suricata/rules/${scirius::params::scirius_ruleset_name}/scirius.reload",
    user    => root,
    minute  => '*',
  }
}

