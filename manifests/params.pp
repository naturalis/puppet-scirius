# == Class scirius::params
#
# This class is meant to be called from scirius
# It sets variables according to platform
#
class scirius::params {
  $ruleset = 'emerging'
  $scirius_port = '8888'
  $scirius_admin = 'admin'
  $scirius_admin_pass = 'changeme'
  $scirius_admin_mail = 'admin@dummy.com'
  $scirius_ruleset_name = 'ETpro'
  $scirius_ruleset_url = 'https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz'
  $scirius_ruleset_update = true
  $scirius_es_address = 'localhost:9200'
  $scirius_es_index = 'logstash-'
  $scirius_kibana_url = "http://${::ipaddress}:5601"
  $scirius_kibana_index = '.kibana'
  $scirius_kibana_version = 4
}
