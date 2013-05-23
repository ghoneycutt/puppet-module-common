require 'spec_helper'

describe 'interface2factname' do
  describe 'should return correct results' do
    it 'should run with eth0' do
      should run.with_params('eth0').and_return('ipaddress_eth0')
    end
    it 'should run with bond0:0' do
      should run.with_params('bond0:0').and_return('ipaddress_bond0_0')
    end
    it 'should run with bond0:1' do
      should run.with_params('bond0:1').and_return('ipaddress_bond0_1')
    end
  end
#  describe 'should fail with invalid parameters' do
#    it 'should fail with no params' do
#      should run.with_params('eth0').and_raise_error(Puppet::ParseError)
#    end
#    it 'should fail with too many params' do
#      should run.with_params('eth0', 'eth1')and_raise_error(Puppet::ParseError)
#    end
#  end
end

#      should run.with_params().and_raise_error(ArgumentError)
#            should run.with_params('User[dan]').and_raise_error(ArgumentError)
#                  should run.with_params('User[dan]', {}).and_raise_error(ArgumentError)
#                        should run.with_params('User[dan]', '').and_return('')
#
