require 'serverspec'

set :backend, :exec

describe file('/etc/nagios/nrpe.d/check_load.cfg') do
  it { should contain('command[check_load]=/usr/lib64/nagios/plugins/check_load -w 12,7,2 -c 14,9,4') }
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_all_disks.cfg') do
  it { should contain('command[check_all_disks]=/usr/lib64/nagios/plugins/check_disk -w 8% -c 5% -A -x /dev/shm -X nfs -X fuse.glusterfs -i /boot') }
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_swap.cfg') do
  it { should contain('command[check_swap]=/usr/lib64/nagios/plugins/check_swap -w 15% -c 5%') }
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_users.cfg') do
  it { should_not be_file }
end
