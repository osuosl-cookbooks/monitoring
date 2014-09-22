require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe file('/etc/nagios/nrpe.d/check_rocky_worker.cfg') do
  it { should contain('check_procs -c 1:1 -a jobs:work') }
  it { should contain('command[check_rocky_worker]') }
end
