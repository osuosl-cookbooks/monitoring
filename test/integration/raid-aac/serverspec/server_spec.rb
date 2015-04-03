require 'serverspec'

set :backend, :exec

# Check that the plugin is installed
describe file('/usr/lib64/nagios/plugins/check-aacraid.py') do
  it { should be_file }
  it { should be_executable }
end

# Check that the nrpe config exists
describe file('/etc/nagios/nrpe.d/check_raid_aac.cfg') do
  its(:content) { should match %r{command[check_raid_aac]=/usr/lib64/nagios/plugins/check-aacraid.py 2>/dev/null} }
end
