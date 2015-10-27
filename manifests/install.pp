# == Class scirius::install
#
class scirius::install {
  # install django
  $packages = [
    'git',
    'expect',
    'python-django',
    'python-imaging',
    'python-pythonmagick',
    'python-markdown',
    'python-textile',
    'python-docutils',
    'python-pip',
    'python-dev',
    'python-pyinotify'
  ]
  ensure_packages($packages)
  # create /opt
  file { '/opt':
    ensure => directory,
  }
  # clone scirius repo
  vcsrepo { '/opt/scirius':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/StamusNetworks/scirius.git',
    require  => File['/opt'],
  } ~>
  # install requierements
  exec { 'install requirements':
    command     => '/usr/bin/pip install -r /opt/scirius/requirements.txt',
    refreshonly => true,
  }
  # prepare start scripts
  file { 'scirius init':
    path   => '/etc/init.d/scirius',
    content => template('scirius/scirius.init.erb'),
    mode   => '1544',
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
  file { 'create scirius expect':
    path    => '/opt/scirius/create_scirius_user.exp',
    content => template('scirius/create_scirius_user.exp.erb'),
    mode    => '0700',
    require => Vcsrepo['/opt/scirius'],
  }
  # create rules dir
  file{ 'rulesdir':
    ensure => directory,
    path   => '/etc/suricata/rules',
  }
  file { 'create_scirues_rulesdir':
    ensure  => directory,
    path    => "/etc/suricata/rules/${suricata::params::scirius_ruleset_name}",
    require => [ File['rulesdir'], Vcsrepo['/opt/scirius'] ],
  }
  # install new db if not exist
  exec { 'initial_syncdb':
    command => '/usr/bin/python manage.py syncdb --no-initial-data --noinput',
    creates => '/opt/scirius/db.sqlite3',
    cwd     => '/opt/scirius',
    require => Vcsrepo['/opt/scirius'],
  }
  # install scirius local settings
  file { 'scirius local settings':
    path    => '/opt/scirius/local_settings.py',
    content => template('scirius/local_settings.py.erb'),
    require => Vcsrepo['/opt/scirius'],
  }
}
