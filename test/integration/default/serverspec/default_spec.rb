require 'serverspec'

set :backend, :exec

%w(
  nrpe
  nagios-plugins
  nagios-plugins-disk
  nagios-plugins-dummy
  nagios-plugins-load
  nagios-plugins-mailq
  nagios-plugins-ntp
  nagios-plugins-procs
  nagios-plugins-swap
  nagios-plugins-users).each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# Only check for this package on older platforms that still support it
if (os[:family] == 'rhel' && os[:release].to_i < 7) ||
   (os[:family] == 'fedora' && os[:release].to_i < 21)
  describe package('nagios-plugins-linux_raid') do
    it { should be_installed }
  end
end

describe file('/etc/nagios/nrpe.d/check_load.cfg') do
  it do
    should contain(
'command[check_load]=/usr/lib64/nagios/plugins/check_load\
 -w 12,7,2 -c 14,9,4')
  end
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_all_disks.cfg') do
  it do
    should contain(
'command[check_all_disks]=/usr/lib64/nagios/plugins/check_disk\
-w 8% -c 5% -A -x /dev/shm -X nfs -X fuse.glusterfs -i /boot')
  end
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_swap.cfg') do
  it do
    should contain(
'command[check_swap]=/usr/lib64/nagios/plugins/check_swap\
-w 15% -c 5%')
  end
  it { should be_owned_by 'nrpe' }
end

describe file('/etc/nagios/nrpe.d/check_users.cfg') do
  it { should_not be_file }
end
