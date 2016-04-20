require 'spec_helper'

describe 'scirius' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "scirius class without any parameters" do
          let(:params) {{ }}

          # should compile
          it { is_expected.to compile.with_all_deps }

          # contain classes
          it { is_expected.to contain_class('scirius') }
          it { is_expected.to contain_class('scirius::params') }
          it { is_expected.to contain_class('scirius::install').that_comes_before('scirius::config') }
          it { is_expected.to contain_class('scirius::config') }
          it { is_expected.to contain_class('scirius::service').that_subscribes_to('scirius::config') }

          # contain packages
          it { is_expected.to contain_package('git') }
          it { is_expected.to contain_package('expect') }
          it { is_expected.to contain_package('python-dev') }
          it { is_expected.to contain_package('python-django') }
          it { is_expected.to contain_package('python-docutils') }
          it { is_expected.to contain_package('python-imaging') }
          it { is_expected.to contain_package('python-markdown') }
          it { is_expected.to contain_package('python-pip') }
          it { is_expected.to contain_package('python-pyinotify') }
          it { is_expected.to contain_package('python-pythonmagick') }
          it { is_expected.to contain_package('python-textile') }
          it { is_expected.to contain_package('south') }

          # contain files
          it { is_expected.to contain_file('/opt') }
          it { is_expected.to contain_file('create scirius expect') }
          it { is_expected.to contain_file('suricatadirdir') }
          it { is_expected.to contain_file('rulesdir') }
          it { is_expected.to contain_file('create_scirues_rulesdir') }
          it { is_expected.to contain_file('scirius local settings') }
          it { is_expected.to contain_file('scirius default') }
          it { is_expected.to contain_file('scirius init') }
          it { is_expected.to contain_file('scirius manage') }
          it { is_expected.to contain_file('file age check') }

          # contain exec
          it { is_expected.to contain_exec('initial_syncdb') }
          it { is_expected.to contain_exec('install requirements') }
          it { is_expected.to contain_exec('scirius_addsuricata') }
          it { is_expected.to contain_exec('scirius_admin_user') }
          it { is_expected.to contain_exec('scirius_defaultruleset') }
          it { is_expected.to contain_exec('scirius_ruleset') }
          it { is_expected.to contain_exec('scirius_updatesuricata') }
          it { is_expected.to contain_exec('update requierements') }

          # contain cron jobs
          it { is_expected.to contain_cron('auto reload suricata') }
          it { is_expected.to contain_cron('update rules') }

          # contain repo's
          it { is_expected.to contain_vcsrepo('/opt/scirius') }

          # contain services
          it { is_expected.to contain_service('scirius') }

        end
      end
    end
  end
end
