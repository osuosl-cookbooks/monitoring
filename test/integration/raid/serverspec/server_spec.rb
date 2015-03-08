require 'serverspec'

set :backend, :exec

describe file('/usr/lib64/nagios/plugins/check_hpacucli') do
  it { should exist }

describe file('/etc/nagios/nrpe.d/check_http.cfg') do
  its(:content) { should match /command\[check_hpacucli\]=\/usr\/lib64\/nagios\/plugins\/check_hpacucli -t/ }
end
