require 'serverspec'

set :backend, :exec

describe file('/etc/nagios/nrpe.d/check_mailq.cfg') do
  it do
    should contain(
'command[check_mailq]=/usr/lib64/nagios/plugins/check_mailq\
-w 5000 -c 10000 -M postfix')
  end
end
