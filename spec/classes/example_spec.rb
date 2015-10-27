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

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('scirius') }
 
          it { is_expected.to contain_class('scirius::params') }
          it { is_expected.to contain_class('scirius::install').that_comes_before('scirius::config') }
          it { is_expected.to contain_class('scirius::config') }
          it { is_expected.to contain_class('scirius::service').that_subscribes_to('scirius::config') }

          it { is_expected.to contain_service('scirius') }
          it { is_expected.to contain_vcsrepo('/opt/scirius') }
        end
      end
    end
  end
end
