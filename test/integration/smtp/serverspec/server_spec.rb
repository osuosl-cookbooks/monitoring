require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe file('/etc/nagios/nrpe.d/check_mailq.cfg') do
  it { should contain('command[check_mailq]=/usr/lib64/nagios/plugins/check_mailq -w 5000 -c 10000 -M postfix') }
end
