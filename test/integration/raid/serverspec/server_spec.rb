require 'serverspec'

set :backend, :exec

describe file('/usr/lib64/nagios/plugins/check_hpacucli') do
  it { should be_file }
end

describe file('/etc/nagios/nrpe.d/check_hpacucli.cfg') do
  its(:content) { should match /command\[check_hpacucli\]=\/usr\/lib64\/nagios\/plugins\/check_hpacucli -t/ }
end
