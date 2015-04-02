require 'serverspec'

set :backend, :exec

# Check that the dependencies are installed
describe package('lsiutil') do
  it { should be_installed }
end

# Check that the plugin is installed
describe file('/usr/lib64/nagios/plugins/check_lsiutil') do
  it { should be_file }
end

# Check that the nrpe config exists
describe file('/etc/nagios/nrpe.d/check_raid_lsiutil.cfg') do
  its(:content) { should match %r{command\[check_raid_lsiutil\]=\/usr\/lib64\/nagios\/plugins\/check_lsiutil} }
end
