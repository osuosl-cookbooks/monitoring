require 'serverspec'

set :backend, :exec

describe package('nagios-plugins-http') do
  it { should be_installed }
end

describe file('/etc/nagios/nrpe.d/check_http.cfg') do
  its(:content) { should match /command\[check_http\]=\/usr\/lib64\/nagios\/plugins\/check_http -H [a-z].+ -I [0-9].+/ }
end
