require 'serverspec'

set :backend, :exec

describe file('/usr/lib64/nagios/plugins/check_hpacucli') do
  it { should be_file }
end

describe file('/etc/nagios/nrpe.d/check_raid_hp.cfg') do
  its(:content) { should match %r{command\[check_raid_hp\]=\/usr\/lib64\/nagios\/plugins\/check_hpacucli -t} }
end
