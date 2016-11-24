require 'spec_helper'
describe 'caddy' do
  context 'with default values for all parameters' do
    it { should contain_class('caddy') }
  end
end
