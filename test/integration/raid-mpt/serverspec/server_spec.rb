require 'serverspec'

set :backend, :exec

# Check that the dependencies are installed
describe package('mptstatus') do
  it { should be_installed }
end

# Check that the plugin is installed
describe file('/usr/lib64/nagios/plugins/check_mpt') do
  it { should be_file }
  it { should be_executable }
end

# Check that the nrpe config exists
describe file('/etc/nagios/nrpe.d/check_raid_mpt.cfg') do
  its(:content) { should match %r{command\[check_raid_mpt\]=/usr/lib64/nagios/plugins/check_mpt} }
end
