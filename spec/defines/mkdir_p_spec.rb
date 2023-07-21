require 'spec_helper'

describe 'common::mkdir_p' do
  describe 'on supported OS RedHat' do
    # The following tests are OS independent, so we only test one supported OS
    redhat = {
      supported_os: [
        {
          'operatingsystem'        => 'RedHat',
          'operatingsystemrelease' => ['8'],
        },
      ],
    }

    on_supported_os(redhat).each do |_os, facts|
      let(:facts) { facts }
      let(:title) { '/test/ing' }

      context 'directory /test/ing with default values' do
        it do
          is_expected.to contain_exec('mkdir_p-/test/ing').only_with(
            {
              'command' => 'mkdir -p /test/ing',
              'unless'  => 'test -d /test/ing',
              'path'    => '/bin:/usr/bin',
            },
          )
        end
      end

      context 'with path set to valid value' do
        let(:params) { { path: '/other/path' } }

        it { is_expected.to contain_exec('mkdir_p-/other/path').with_command('mkdir -p /other/path') }
        it { is_expected.to contain_exec('mkdir_p-/other/path').with_unless('test -d /other/path') }
      end

      describe 'variable type and content validations' do
        let(:validation_params) { {} }

        validations = {
          'Stdlib::Absolutepath' => {
            name:    ['path'],
            valid:   ['/test/ing'],
            invalid: ['../invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a Stdlib::Absolutepath',
          },
        }

        validations.sort.each do |type, var|
          var[:name].each do |var_name|
            var[:valid].each do |valid|
              context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
                let(:params) { validation_params.merge({ "#{var_name}": valid, }) }

                it { is_expected.to compile }
              end
            end

            var[:invalid].each do |invalid|
              context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
                let(:params) { validation_params.merge({ "#{var_name}": invalid, }) }

                it 'fails' do
                  expect {
                    is_expected.to contain_class(:subject)
                  }.to raise_error(Puppet::Error, %r{#{var[:message]}})
                end
              end
            end
          end # var[:name].each
        end # validations.sort.each
      end # describe 'variable type and content validations'
    end
  end
end
