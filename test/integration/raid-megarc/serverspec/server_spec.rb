require 'serverspec'

set :backend, :exec

# Check that the dependencies are installed
describe package('megacli') do
  it { should be_installed }
end

# Check that the plugin is installed
describe file('/usr/lib64/nagios/plugins/check_megarc') do
  it { should be_file }
end

# Check that the nrpe config exists
describe file('/etc/nagios/nrpe.d/check_raid_megarc.cfg') do
  its(:content) { should match %r{command\[check_raid_megarc\]=\/usr\/lib64\/nagios\/plugins\/check_megarc} }
end
