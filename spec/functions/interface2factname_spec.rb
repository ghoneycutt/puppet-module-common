require 'spec_helper'

describe 'interface2factname' do
  describe 'is_expected.to return correct results' do
    it 'is_expected.to run with eth0' do
      is_expected.to run.with_params('eth0').and_return('ipaddress_eth0')
    end

    it 'is_expected.to run with bond0:0' do
      is_expected.to run.with_params('bond0:0').and_return('ipaddress_bond0_0')
    end

    it 'is_expected.to run with bond0:1' do
      is_expected.to run.with_params('bond0:1').and_return('ipaddress_bond0_1')
    end
  end
end
