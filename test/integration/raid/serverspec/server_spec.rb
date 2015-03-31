require 'serverspec'

set :backend, :exec

# Check that the dependencies are installed
describe package('hpacucli') do
  it { should be_installed }
end

# Check that the plugin is installed
describe file('/usr/lib64/nagios/plugins/check_hpacucli') do
  it { should be_file }
end

# Check that the nrpe config exists
describe file('/etc/nagios/nrpe.d/check_raid_hp.cfg') do
  its(:content) { should match %r{command\[check_raid_hp\]=\/usr\/lib64\/nagios\/plugins\/check_hpacucli -t} }
end
