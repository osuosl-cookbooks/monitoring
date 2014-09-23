require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe file('/etc/nagios/nrpe.d/check_rocky_worker.cfg') do
  it { should contain('command[check_rocky_worker]=/usr/lib64/nagios/plugins/check_procs -c 1:1 -a jobs:work') }
end

describe file('/usr/share/munin/plugins/pdf_queue') do
  it { should contain('graph_title PDF Generation Queue') }
end

describe file('/etc/munin/plugin-conf.d/pdf_queue') do
  it { should contain('env.host localhost') }
  it { should contain('env.name rocky') }
  it { should contain('env.password rocky') }
  it { should contain('env.user rocky') }
  it { should be_mode 600 }
  it { should be_owned_by 'munin' }
  it { should be_readable.by('owner') }
end

describe file('/etc/munin/plugins/pdf_queue') do
  it { should be_linked_to '/usr/share/munin/plugins/pdf_queue' }
end
