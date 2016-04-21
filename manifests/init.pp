# == Class: scirius
#
# Full description of class scirius here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class scirius (
  $package_name = $scirius::params::package_name,
  $service_name = $scirius::params::service_name,
  $scirius_port = $scirius::params::scirius_port,
  $scirius_admin = $scirius::params::scirius_admin,
  $scirius_admin_pass = $scirius::params::scirius_admin_pass,
  $scirius_admin_mail = $scirius::params::scirius_admin_mail,
  $scirius_ruleset_name = $scirius::params::scirius_ruleset_name,
  $scirius_ruleset_url = $scirius::params::scirius_ruleset_url,
  $scirius_ruleset_update = $scirius::params::scirius_ruleset_update,
  $scirius_es_address = $scirius::params::scirius_es_address,
  $scirius_es_index = $scirius::params::scirius_es_index,
  $scirius_kibana_url = $scirius::params::scirius_kibana_url,
  $scirius_kibana_index = $scirius::params::scirius_kibana_index,
  $scirius_kibana_version = $scirius::params::scirius_kibana_version,
) inherits scirius::params {
  # validate parameters
  validate_string($package_name)
  validate_string($service_name)
  validate_string($scirius_port)
  validate_string($scirius_admin)
  validate_string($scirius_admin_pass)
  validate_string($scirius_admin_mail)
  validate_string($scirius_ruleset_name)
  validate_string($scirius_ruleset_url)
  validate_bool($scirius_ruleset_update)
  validate_string($scirius_es_address)
  validate_string($scirius_es_index)
  validate_string($scirius_kibana_url)
  validate_string($scirius_kibana_index)
  validate_string($scirius_kibana_version)


  class { '::scirius::install': } ->
  class { '::scirius::config': } ~>
  class { '::scirius::service': } ->
  Class['::scirius']
}
